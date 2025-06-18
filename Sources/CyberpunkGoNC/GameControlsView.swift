import SwiftUI

struct GameControlsView: View {
    @ObservedObject var gameState: GameState
    @State private var showingGangLegend = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Selected District Info
            if let selectedDistrict = gameState.selectedDistrict {
                SelectedDistrictView(district: selectedDistrict, gameState: gameState)
            } else {
                Text("TAP A DISTRICT TO SELECT")
                    .font(.custom("Courier", size: 14))
                    .foregroundColor(Color(red: 0, green: 1, blue: 1)) // cyan equivalent
                    .opacity(0.8)
            }
            
            // Game Status Bar
            HStack {
                VStack(alignment: .leading) {
                    Text("ROUND: \(gameState.currentRound)")
                        .font(.custom("Courier", size: 12))
                        .foregroundColor(.green)
                    
                    Text("PHASE: \(gameState.currentPhase)")
                        .font(.custom("Courier", size: 12))
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                Button("GANG INFO") {
                    showingGangLegend.toggle()
                }
                .font(.custom("Courier", size: 12))
                .foregroundColor(Color(red: 0, green: 1, blue: 1)) // cyan equivalent
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(red: 0, green: 1, blue: 1).opacity(0.2)) // cyan equivalent
                .cornerRadius(4)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingGangLegend) {
            GangLegendView(gameState: gameState)
        }
    }
}

struct SelectedDistrictView: View {
    let district: District
    @ObservedObject var gameState: GameState
    
    // Calculate total units in district
    private var totalUnitsInDistrict: Int {
        district.units.values.reduce(0) { total, units in
            total + units.count
        }
    }
    
    // Get gang with most units
    private var dominatingGang: (gang: Gang, count: Int)? {
        guard let dominantGangId = district.units.max(by: { $0.value.count < $1.value.count })?.key,
              let gang = gameState.gangs.first(where: { $0.id == dominantGangId }) else {
            return nil
        }
        let count = district.units[dominantGangId]?.count ?? 0
        return (gang, count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // District Header
            HStack {
                Text(district.name.uppercased())
                    .font(.custom("Courier", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0, green: 1, blue: 1)) // cyan equivalent
                
                Spacer()
                
                // Total units indicator
                Text("\(totalUnitsInDistrict) UNITS")
                    .font(.custom("Courier", size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Dominance information
            if let (dominatingGang, count) = dominatingGang {
                HStack {
                    Circle()
                        .fill(dominatingGang.color)
                        .frame(width: 8, height: 8)
                    
                    Text("DOMINATED BY \(dominatingGang.name.uppercased()) (\(count)/\(totalUnitsInDistrict))")
                        .font(.custom("Courier", size: 10))
                        .foregroundColor(dominatingGang.color)
                        .fontWeight(.bold)
                }
            }
            
            // Gang Units
            if !district.units.isEmpty {
                Text("GANG BREAKDOWN:")
                    .font(.custom("Courier", size: 12))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 4)
                
                ForEach(Array(district.units.keys.sorted(by: { gangId1, gangId2 in
                    let count1 = district.units[gangId1]?.count ?? 0
                    let count2 = district.units[gangId2]?.count ?? 0
                    return count1 > count2
                })), id: \.self) { gangId in
                    if let gang = gameState.gangs.first(where: { $0.id == gangId }),
                       let units = district.units[gangId],
                       !units.isEmpty {
                        GangUnitsInfoView(gang: gang, units: units)
                    }
                }
            } else {
                Text("NO GANG PRESENCE")
                    .font(.custom("Courier", size: 12))
                    .foregroundColor(.gray)
                    .italic()
            }
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 0, green: 1, blue: 1), lineWidth: 1) // cyan equivalent
        )
    }
}

struct GangUnitsInfoView: View {
    let gang: Gang
    let units: [Unit]
    
    // Helper function to get border color for unit types (matching DistrictMapView)
    private func borderColorForUnitType(_ unitType: UnitType) -> Color {
        switch unitType {
        case .solo:
            return Color.orange
        case .techie:
            return Color.green
        case .netrunner:
            return Color.blue
        case .drone:
            return Color.green // Same as techies
        }
    }
    
    // Helper function to get unit size
    private func sizeForUnitType(_ unitType: UnitType) -> CGFloat {
        switch unitType {
        case .drone:
            return 8
        default:
            return 12 // Slightly smaller for info panel
        }
    }
    
    // Helper function to get unit type symbol/description
    private func symbolForUnitType(_ unitType: UnitType) -> String {
        switch unitType {
        case .solo:
            return "⚔️"
        case .techie:
            return "🔧"
        case .netrunner:
            return "💻"
        case .drone:
            return "🤖"
        }
    }
    
    // Helper function to get unit type tactical role
    private func tacticalRoleForUnitType(_ unitType: UnitType) -> String {
        switch unitType {
        case .solo:
            return "ASSAULT"
        case .techie:
            return "SUPPORT"
        case .netrunner:
            return "CYBER"
        case .drone:
            return "RECON"
        }
    }
    
    // Count units by type
    private var unitCounts: [UnitType: Int] {
        Dictionary(grouping: units, by: { $0.type })
            .mapValues { $0.count }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Gang Header
            HStack {
                Circle()
                    .fill(gang.color)
                    .frame(width: 12, height: 12)
                
                Text(gang.name.uppercased())
                    .font(.custom("Courier", size: 11))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(units.count) TOTAL")
                    .font(.custom("Courier", size: 10))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Unit Type Breakdown
            VStack(alignment: .leading, spacing: 4) {
                ForEach([UnitType.solo, .techie, .netrunner, .drone], id: \.self) { unitType in
                    if let count = unitCounts[unitType], count > 0 {
                        HStack(spacing: 6) {
                            // Unit type indicator
                            Circle()
                                .fill(gang.color)
                                .frame(width: sizeForUnitType(unitType), height: sizeForUnitType(unitType))
                                .overlay(
                                    Circle()
                                        .stroke(borderColorForUnitType(unitType), lineWidth: 1.5)
                                )
                            
                            // Unit count
                            Text("\(count)")
                                .font(.custom("Courier", size: 12))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .frame(minWidth: 20, alignment: .leading)
                            
                            // Unit type name and description
                            VStack(alignment: .leading, spacing: 1) {
                                Text(unitType.rawValue.uppercased())
                                    .font(.custom("Courier", size: 9))
                                    .foregroundColor(borderColorForUnitType(unitType))
                                    .fontWeight(.bold)
                                
                                Text(tacticalRoleForUnitType(unitType))
                                    .font(.custom("Courier", size: 7))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            // Unit type symbol
                            Text(symbolForUnitType(unitType))
                                .font(.system(size: 10))
                                .opacity(0.8)
                        }
                        .padding(.vertical, 1)
                    }
                }
            }
        }
        .padding(.leading, 16)
        .padding(.vertical, 4)
    }
}

struct GangLegendView: View {
    @ObservedObject var gameState: GameState
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("GANG TERRITORIES")
                        .font(.custom("Courier", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0, green: 1, blue: 1)) // cyan equivalent
                        .padding(.top)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(gameState.gangs) { gang in
                                GangDetailView(gang: gang, gameState: gameState)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: 
                Button("CLOSE") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color(red: 0, green: 1, blue: 1)) // cyan equivalent
                .font(.custom("Courier", size: 14))
            )
            #else
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("CLOSE") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(red: 0, green: 1, blue: 1)) // cyan equivalent
                    .font(.custom("Courier", size: 14))
                }
            }
            #endif
        }
    }
}

struct GangDetailView: View {
    let gang: Gang
    @ObservedObject var gameState: GameState
    
    var gangTerritories: [District] {
        gameState.districts.filter { district in
            district.units.keys.contains(gang.id)
        }
    }
    
    var totalUnits: Int {
        gangTerritories.reduce(0) { total, district in
            total + (district.units[gang.id]?.count ?? 0)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(gang.color)
                    .frame(width: 20, height: 20)
                
                Text(gang.name.uppercased())
                    .font(.custom("Courier", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(totalUnits) TOTAL UNITS")
                    .font(.custom("Courier", size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            if !gangTerritories.isEmpty {
                Text("TERRITORIES:")
                    .font(.custom("Courier", size: 10))
                    .foregroundColor(.white.opacity(0.6))
                
                ForEach(gangTerritories) { district in
                    HStack {
                        Text("• \(district.name)")
                            .font(.custom("Courier", size: 11))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("\(district.units[gang.id]?.count ?? 0) units")
                            .font(.custom("Courier", size: 10))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.leading, 16)
                }
            } else {
                Text("NO TERRITORIES")
                    .font(.custom("Courier", size: 11))
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.leading, 16)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(gang.color.opacity(0.5), lineWidth: 1)
        )
    }
}
