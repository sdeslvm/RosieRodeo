import SwiftUI

struct GameLevelGenerateModel: View {
    @State private var path: [CGPoint] = []
    @State private var isDrawing = false
    @State private var gameState: GameState = .drawing
    @State private var playerPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var bullPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var rosePosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var blocks: [CGPoint] = []
    @State private var showGameOver = false
    @State private var isWin = false
    @State private var currentPathIndex = 0
    @State private var playerSpeed: CGFloat = 68.0
    @State private var bullSpeed: CGFloat = 48.0
    @State private var bullStartDelay: Double = 1.5
    @State private var bullStartTime: Date?
    @State private var progress: CGFloat = 0
    @State private var lastUpdateTime: Date?
    @State private var showWinScreen = false
    @State private var showLoseScreen = false
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard1: String = "background1"
    
    
    
    enum GameState {
        case drawing
        case playing
        case gameOver
    }
    
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
                
                if showWinScreen {
                                WinView()
                                    .transition(.opacity) // Добавьте анимацию появления
                                    .zIndex(1) // Убедитесь, что экран находится поверх остальных элементов
                            }

                            if showLoseScreen {
                                LoseView()
                                    .transition(.opacity) // Добавьте анимацию появления
                                    .zIndex(1) // Убедитесь, что экран находится поверх остальных элементов
                            }
                
                // Game elements
                // Blocks
                ForEach(blocks.indices, id: \.self) { index in
                    Image("preblock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .position(blocks[index])
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                
                // Rose (win point)
                Image("winRose")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .position(rosePosition)
                    .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 2)
                
                // Player
                Image("you")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .position(playerPosition)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .overlay(
                        Path { path in
                            if let firstPoint = self.path.first {
                                path.move(to: firstPoint)
                                for point in self.path {
                                    path.addLine(to: point)
                                }
                            }
                        }
                        .stroke(Color.blue, lineWidth: 4)
                        .shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 0)
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if gameState == .drawing {
                                    if !isDrawing {
                                        isDrawing = true
                                        path = [value.location]
                                    } else {
                                        path.append(value.location)
                                    }
                                }
                            }
                            .onEnded { value in
                                if gameState == .drawing {
                                    isDrawing = false
                                    startGame()
                                }
                            }
                    )
                
                // Bull
                Image("bull")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .position(bullPosition)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(currentSelectedCloseCard1)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.05)
            )
            .onAppear {
                setupLevel(geometry: geometry)
            }
//            .alert(isPresented: $showGameOver) {
//                Alert(
//                    title: Text(isWin ? "Victory!" : "Game Over"),
//                    message: Text(isWin ? "You reached the rose!" : "The bull caught you!"),
//                    dismissButton: .default(Text("OK")) {
//                        resetGame()
//                    }
//                )
//            }
        }
    }
    
    private func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }
    
    private func setupLevel(geometry: GeometryProxy) {
        // Set initial positions
        bullPosition = CGPoint(x: geometry.size.width / 2, y: 100)
        playerPosition = CGPoint(x: geometry.size.width / 2, y: 200)
        rosePosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height - 200)
        
        // Generate random blocks
        blocks = []
        let safeZoneRadius: CGFloat = 100 // Радиус безопасной зоны вокруг розы
        let centerZoneRadius: CGFloat = 150 // Радиус центральной зоны
        
        // Сначала размещаем блоки в центре экрана
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        // Размещаем 2-3 блока в центре экрана
        let centerBlocksCount = Int.random(in: 2...3)
        for _ in 0..<centerBlocksCount {
            var validPosition = false
            var blockPosition: CGPoint
            
            repeat {
                // Генерируем позицию блока в центральной зоне
                let angle = CGFloat.random(in: 0...(2 * .pi))
                let distance = CGFloat.random(in: 0...centerZoneRadius)
                let x = centerX + distance * cos(angle)
                let y = centerY + distance * sin(angle)
                blockPosition = CGPoint(x: x, y: y)
                
                // Проверяем, не находится ли блок в безопасной зоне вокруг розы
                let distanceToRose = sqrt(
                    pow(blockPosition.x - rosePosition.x, 2) +
                    pow(blockPosition.y - rosePosition.y, 2)
                )
                
                let isInSafeZone = distanceToRose < safeZoneRadius
                validPosition = !isInSafeZone
            } while !validPosition
            
            blocks.append(blockPosition)
        }
        
        // Затем размещаем остальные блоки по краям
        let remainingBlocks = 5 - centerBlocksCount
        for _ in 0..<remainingBlocks {
            var validPosition = false
            var blockPosition: CGPoint
            
            repeat {
                // Генерируем позицию блока по краям экрана
                let side = Int.random(in: 0...3) // 0: top, 1: right, 2: bottom, 3: left
                let x: CGFloat
                let y: CGFloat
                
                switch side {
                case 0: // top
                    x = CGFloat.random(in: 50...(geometry.size.width - 50))
                    y = CGFloat.random(in: 150...300)
                case 1: // right
                    x = CGFloat.random(in: (geometry.size.width - 200)...(geometry.size.width - 50))
                    y = CGFloat.random(in: 150...(geometry.size.height - 150))
                case 2: // bottom
                    x = CGFloat.random(in: 50...(geometry.size.width - 50))
                    y = CGFloat.random(in: (geometry.size.height - 300)...(geometry.size.height - 150))
                default: // left
                    x = CGFloat.random(in: 50...200)
                    y = CGFloat.random(in: 150...(geometry.size.height - 150))
                }
                
                blockPosition = CGPoint(x: x, y: y)
                
                // Проверяем, не находится ли блок в безопасной зоне вокруг р
                let distanceToRose = sqrt(
                    pow(blockPosition.x - rosePosition.x, 2) +
                    pow(blockPosition.y - rosePosition.y, 2)
                )
                
                let isInSafeZone = distanceToRose < safeZoneRadius
                validPosition = !isInSafeZone
            } while !validPosition
            
            blocks.append(blockPosition)
        }
    }
    
    private func startGame() {
        gameState = .playing
        currentPathIndex = 0
        progress = 0
        bullStartTime = Date()
        // Start game loop
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            if gameState == .playing {
                updateGame()
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func updateGame() {
        let currentTime = Date()
        let deltaTime = lastUpdateTime.map { currentTime.timeIntervalSince($0) } ?? 0.016
        lastUpdateTime = currentTime
        
        // Move player along path
        if currentPathIndex < path.count - 1 {
            let currentPoint = path[currentPathIndex]
            let nextPoint = path[currentPathIndex + 1]
            
            let dx = nextPoint.x - currentPoint.x
            let dy = nextPoint.y - currentPoint.y
            let distance = sqrt(dx * dx + dy * dy)
            
            progress += playerSpeed * CGFloat(deltaTime) / distance
            
            if progress >= 1.0 {
                progress = 0
                currentPathIndex += 1
                if currentPathIndex < path.count {
                    playerPosition = path[currentPathIndex]
                }
            } else {
                let newPosition = CGPoint(
                    x: currentPoint.x + dx * progress,
                    y: currentPoint.y + dy * progress
                )
                playerPosition = newPosition
            }
        }
        
        // Move bull towards player only after delay
        if let startTime = bullStartTime,
           currentTime.timeIntervalSince(startTime) >= bullStartDelay {
            moveBullTowardsPlayer(deltaTime: deltaTime)
        }
        
        // Check collisions
        checkCollisions()
    }
    
    private func moveBullTowardsPlayer(deltaTime: TimeInterval) {
        let dx = playerPosition.x - bullPosition.x
        let dy = playerPosition.y - bullPosition.y
        let distance = sqrt(dx * dx + dy * dy)
        
        if distance < bullSpeed * CGFloat(deltaTime) {
            bullPosition = playerPosition
        } else {
            let ratio = bullSpeed * CGFloat(deltaTime) / distance
            bullPosition = CGPoint(
                x: bullPosition.x + dx * ratio,
                y: bullPosition.y + dy * ratio
            )
        }
    }
    
    private func checkCollisions() {
        // Check collision with blocks
        for block in blocks {
            if isColliding(playerPosition, block) {
                gameOver(win: false)
                return
            }
        }
        
        // Check collision with bull
        if isColliding(playerPosition, bullPosition) {
            gameOver(win: false)
            return
        }
        
        // Check if reached rose - only if we're at the end of the path
        if currentPathIndex >= path.count - 1 && isColliding(playerPosition, rosePosition) {
            gameOver(win: true)
        }
    }
    
    private func isColliding(_ point1: CGPoint, _ point2: CGPoint) -> Bool {
        let distance = sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
        return distance < 40 // Увеличили радиус коллизии
    }
    
    private func gameOver(win: Bool) {
        gameState = .gameOver
        if win {
            showWinScreen = true // Показать экран победы
        } else {
            showLoseScreen = true // Показать экран поражения
        }
    }
    
    private func resetGame() {
        path = []
        isDrawing = false
        gameState = .drawing
        showGameOver = false
        isWin = false
        currentPathIndex = 0
        progress = 0
        bullStartTime = nil
    }
}

struct WinView: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    @AppStorage("unlockedLevels") private var unlockedLevels: Int = 1

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.winPlate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(1.15)
                    .onTapGesture {
                        coinscore += 100
                        unlockedLevels += 1
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
        }
    }
}

struct LoseView: View {
    @AppStorage("coinscore") var coinscore: Int = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.loseView)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(1.15)
                    .onTapGesture {
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
        }
    }
}

#Preview {
    GameLevelGenerateModel()
}
