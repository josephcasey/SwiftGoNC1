import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cyberpunk background
                LinearGradient(
                    colors: [.black, Color.purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack {
                        Text("NIGHT CITY")
                            .font(.custom("Courier", size: 32))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0, green: 1, blue: 1)) // cyan equivalent
                            .textCase(.uppercase)
                        
                        Text("Gang Territory Control")
                            .font(.custom("Courier", size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top)
                    
                    // Interactive District Map
                    DistrictMapView(gameState: gameState)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Game Controls
                    GameControlsView(gameState: gameState)
                        .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    EmptyView()
                }
            }
        }
    }
}
