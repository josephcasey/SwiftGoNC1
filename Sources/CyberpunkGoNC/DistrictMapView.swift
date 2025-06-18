import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct DistrictMapView: View {
    @ObservedObject var gameState: GameState
    @State private var mapSize: CGSize = .zero
    
    var fallbackBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.black, Color.purple.opacity(0.2), Color.black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Grid pattern for cyberpunk feel
            Path { path in
                for i in stride(from: 0, to: 400, by: 40) {
                    path.move(to: CGPoint(x: i, y: 0))
                    path.addLine(to: CGPoint(x: i, y: 400))
                    path.move(to: CGPoint(x: 0, y: i))
                    path.addLine(to: CGPoint(x: 400, y: i))
                }
            }
            .stroke(Color(red: 0, green: 1, blue: 1).opacity(0.1), lineWidth: 1)
            
            Text("NIGHT CITY\nMAP LOADING...")
                .font(.custom("Courier", size: 16))
                .foregroundColor(Color(red: 0, green: 1, blue: 1).opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background map - Night City (with fallback)
                Group {
                    Image("NightCityMap")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .background(Color.black) // Ensure background while loading
                        .onAppear {
                            print("Attempting to load NightCityMap image")
                        }
                }
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0, green: 1, blue: 1), lineWidth: 2)
                )
                
                // District boundaries and units
                ForEach(gameState.districts) { district in
                    DistrictView(
                        district: district,
                        gameState: gameState,
                        mapSize: geometry.size,
                        isSelected: gameState.selectedDistrict?.id == district.id
                    )
                }
                
                // Selection indicator
                if let selectedDistrict = gameState.selectedDistrict {
                    SelectionIndicatorView(
                        district: selectedDistrict,
                        mapSize: geometry.size
                    )
                }
            }
            .onAppear {
                mapSize = geometry.size
            }
            .onChange(of: geometry.size) { newSize in
                mapSize = newSize
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        gameState.selectDistrict(at: value.location, in: geometry.size)
                    }
            )
        }
        .aspectRatio(2/3, contentMode: .fit) // Correct aspect ratio for Night City map (1024x1536)
    }
}

struct DistrictView: View {
    let district: District
    @ObservedObject var gameState: GameState
    let mapSize: CGSize
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            // District boundary (optional visualization)
            if isSelected {
                DistrictBoundaryShape(boundaries: district.boundaries, mapSize: mapSize)
                    .stroke(Color(red: 0, green: 1, blue: 1), lineWidth: 3) // cyan equivalent
                    .opacity(0.7)
            }
            
            // Gang units
            ForEach(Array(district.units.keys), id: \.self) { gangId in
                if let gang = gameState.gangs.first(where: { $0.id == gangId }),
                   let units = district.units[gangId] {
                    GangUnitsView(
                        gang: gang,
                        units: units,
                        center: scalePoint(district.center, to: mapSize),
                        mapSize: mapSize
                    )
                }
            }
        }
    }
    
    private func scalePoint(_ point: CGPoint, to size: CGSize) -> CGPoint {
        return CGPoint(
            x: point.x * (size.width / 1024),
            y: point.y * (size.height / 1536)
        )
    }
}

struct DistrictBoundaryShape: Shape {
    let boundaries: [CGPoint]
    let mapSize: CGSize
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard !boundaries.isEmpty else { return path }
        
        let scaledPoints = boundaries.map { point in
            CGPoint(
                x: point.x * (mapSize.width / 1024),
                y: point.y * (mapSize.height / 1536)
            )
        }
        
        path.move(to: scaledPoints[0])
        for point in scaledPoints.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        
        return path
    }
}

struct GangUnitsView: View {
    let gang: Gang
    let units: [Unit]
    let center: CGPoint
    let mapSize: CGSize
    
    var body: some View {
        ForEach(Array(units.enumerated()), id: \.element.id) { index, unit in
            UnitView(unit: unit, gang: gang)
                .position(unitPosition(for: index))
        }
    }
    
    private func unitPosition(for index: Int) -> CGPoint {
        let angle = Double(index) * (2 * Double.pi / Double(units.count))
        let radius = min(mapSize.width, mapSize.height) * 0.03 // Adjust spread
        
        return CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }
}

struct UnitView: View {
    let unit: Unit
    let gang: Gang
    
    var body: some View {
        ZStack {
            // Main unit circle
            Circle()
                .fill(gang.color)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            
            // Unit type indicator
            if unit.type == .drone {
                Circle()
                    .fill(Color.white)
                    .frame(width: 6, height: 6)
            }
        }
    }
}

struct SelectionIndicatorView: View {
    let district: District
    let mapSize: CGSize
    
    var body: some View {
        Circle()
            .stroke(Color(red: 0, green: 1, blue: 1), lineWidth: 3) // cyan equivalent
            .frame(width: 60, height: 60)
            .scaleEffect(1.2)
            .opacity(0.8)
            .position(scalePoint(district.center, to: mapSize))
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: 1.2)
    }
    
    private func scalePoint(_ point: CGPoint, to size: CGSize) -> CGPoint {
        return CGPoint(
            x: point.x * (size.width / 1024),
            y: point.y * (size.height / 1536)
        )
    }
}
