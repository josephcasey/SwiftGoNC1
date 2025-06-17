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
                
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // Interactive District Map (Fixed height to prevent resizing)
                        DistrictMapView(gameState: gameState)
                            .frame(height: geometry.size.height * 0.65) // 65% of available height
                            .padding(.top, 10)
                        
                        // Game Controls (Flexible space for district info)
                        GameControlsView(gameState: gameState)
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
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
