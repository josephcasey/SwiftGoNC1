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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // District Header
            HStack {
                Text(district.name.uppercased())
                    .font(.custom("Courier", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0, green: 1, blue: 1)) // cyan equivalent
                
                Spacer()
                
                if let dominantGang = district.dominantGang,
                   let gang = gameState.gangs.first(where: { $0.id == dominantGang }) {
                    Text("CONTROLLED BY \(gang.name.uppercased())")
                        .font(.custom("Courier", size: 10))
                        .foregroundColor(gang.color)
                }
            }
            
            // Gang Units
            if !district.units.isEmpty {
                Text("ACTIVE GANGS:")
                    .font(.custom("Courier", size: 12))
                    .foregroundColor(.white.opacity(0.8))
                
                ForEach(Array(district.units.keys), id: \.self) { gangId in
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
    
    var body: some View {
        HStack {
            // Gang color indicator
            Circle()
                .fill(gang.color)
                .frame(width: 12, height: 12)
            
            Text(gang.name.uppercased())
                .font(.custom("Courier", size: 11))
                .foregroundColor(.white)
            
            Spacer()
            
            Text("\(units.count) UNITS")
                .font(.custom("Courier", size: 11))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.leading, 16)
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
