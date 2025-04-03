import SwiftUI

struct LevelsView: View {
    @AppStorage("unlockedLevels") private var unlockedLevels: Int = 1
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 4)
    let totalLevels = 20
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundStyle(.white)
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MENU
                            }
                        Spacer()
                    }
                    Spacer()
                }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(1...totalLevels, id: \.self) { level in
                            LevelButton(level: level, isUnlocked: level <= unlockedLevels)
                                .frame(width: (geometry.size.width - 60) / 4)
                        }
                    }
                    .padding()
                }
                .padding(.top, 120)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundLevels)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

struct LevelButton: View {
    let level: Int
    let isUnlocked: Bool
    
    var body: some View {
        Button(action: {
            if isUnlocked {
                NavGuard.shared.currentScreen = .GAME
            }
        }) {
            ZStack {
                Image(String(level))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .opacity(isUnlocked ? 1 : 0.5)
                
                if !isUnlocked {
                    Color.black.opacity(0.3)
                        .frame(width: 50, height: 50)
                }
            }
        }
        .disabled(!isUnlocked)
    }
}

#Preview {
    LevelsView()
}

