import SwiftUI

struct DistrictMapView: View {
    @ObservedObject var gameState: GameState
    @State private var mapSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background map (placeholder - you can add your actual image)
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0, green: 1, blue: 1), lineWidth: 2) // cyan equivalent
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
        .aspectRatio(1024/1536, contentMode: .fit) // Original image aspect ratio
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
            
            // District name label
            Text(district.name)
                .font(.custom("Courier", size: 12))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(4)
                .background(Color.black.opacity(0.7))
                .cornerRadius(4)
                .position(scalePoint(district.center, to: mapSize))
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
