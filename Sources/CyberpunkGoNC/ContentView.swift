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
                    HStack(spacing: 10) {
                        // Main game area (map + controls)
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
                        
                        // Action Discs Column
                        ActionDiscColumnView(gameState: gameState)
                            .frame(width: 100) // Fixed width for action discs
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

struct ActionDiscColumnView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(spacing: 15) {
            Text("ACTION DISCS")
                .font(.custom("Courier", size: 12))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1, green: 1, blue: 0)) // Yellow header
                .padding(.bottom, 10)
            
            ForEach(gameState.actionDiscs) { actionDisc in
                ActionDiscView(
                    actionDisc: actionDisc,
                    isSelected: gameState.selectedActionDisc?.id == actionDisc.id
                ) {
                    gameState.selectActionDisc(actionDisc)
                }
            }
            
            Spacer()
        }
        .padding(.vertical)
    }
}

struct ActionDiscView: View {
    let actionDisc: ActionDisc
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 5) {
            // Disc circle
            ZStack {
                Circle()
                    .fill(actionDisc.color)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(
                                isSelected ? Color(red: 0, green: 1, blue: 1) : Color.white,
                                lineWidth: isSelected ? 3 : 2
                            )
                    )
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .shadow(color: isSelected ? Color(red: 0, green: 1, blue: 1) : Color.clear, radius: 5)
                
                // Icon
                Image(systemName: actionDisc.icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Action label
            Text(actionDisc.type.displayName)
                .font(.custom("Courier", size: 8))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 80)
        }
        .opacity(actionDisc.isAvailable ? 1.0 : 0.5)
        .onTapGesture {
            if actionDisc.isAvailable {
                onTap()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
