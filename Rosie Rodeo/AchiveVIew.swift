import SwiftUI

struct Achievement: Identifiable {
    let id: Int
    let image: String
    let title: String
    let description: String
    let unlockTime: TimeInterval
}

struct AchiveView: View {
    @State private var achievements: [Achievement] = [
        Achievement(id: 1, image: "achive1", title: "Daily Champion", description: "Complete 5 levels in one day", unlockTime: 24 * 3600),
        Achievement(id: 2, image: "achive2", title: "Speed Runner", description: "Complete a level in under 30 seconds", unlockTime: 48 * 3600),
        Achievement(id: 3, image: "achive3", title: "Perfect Score", description: "Get 3 stars on any level", unlockTime: 72 * 3600),
        Achievement(id: 4, image: "achive4", title: "Collector", description: "Collect 100 coins in one level", unlockTime: 96 * 3600)
    ]
    
    @AppStorage("lastUnlockTime1") private var lastUnlockTime1: Double = Date().timeIntervalSince1970
    @AppStorage("lastUnlockTime2") private var lastUnlockTime2: Double = Date().timeIntervalSince1970
    @AppStorage("lastUnlockTime3") private var lastUnlockTime3: Double = Date().timeIntervalSince1970
    @AppStorage("lastUnlockTime4") private var lastUnlockTime4: Double = Date().timeIntervalSince1970
    
    @State private var remainingTimes: [TimeInterval] = Array(repeating: 24 * 3600, count: 4)
    @State private var timer: Timer?
    
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
                
                VStack(spacing: 20) {
                    // First row (achievements 1 and 2)
                    HStack(spacing: 20) {
                        ForEach(0..<2) { index in
                            AchievementCard(achievement: achievements[index], 
                                         remainingTime: remainingTimes[index])
                        }
                    }
                    
                    // Second row (achievements 3 and 4)
                    HStack(spacing: 20) {
                        ForEach(2..<4) { index in
                            AchievementCard(achievement: achievements[index], 
                                         remainingTime: remainingTimes[index])
                        }
                    }
                }
                .padding(.top, 80)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundShop)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let currentTime = Date().timeIntervalSince1970
            
            // Update remaining time for each achievement
            remainingTimes[0] = max(0, achievements[0].unlockTime - (currentTime - lastUnlockTime1))
            remainingTimes[1] = max(0, achievements[1].unlockTime - (currentTime - lastUnlockTime2))
            remainingTimes[2] = max(0, achievements[2].unlockTime - (currentTime - lastUnlockTime3))
            remainingTimes[3] = max(0, achievements[3].unlockTime - (currentTime - lastUnlockTime4))
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let remainingTime: TimeInterval
    
    var body: some View {
        ZStack {
            Image(achievement.image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 210)
                .opacity(0.5)
            
            Color.black.opacity(0.3)
                .frame(width: 150, height: 210)
            
            VStack(spacing: 5) {
                Text("Unlocks in")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                
                Text(formatTime(remainingTime))
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
            }
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}

#Preview {
    AchiveView()
}

