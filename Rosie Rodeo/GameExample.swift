//import SwiftUI
//
//struct MainGame: View {
//    @State private var nests: [CGPoint] = [] // Массив для хранения позиций целей
//    @State private var objects: [GameObject] = [] // Массив для хранения всех объектов (birds, hel1, plane1)
//    @State private var warnings: [Warning] = [] // Массив для хранения предупреждений
//    @State private var crashes: [Crash] = [] // Массив для хранения столкновений
//    @State private var isGameOver = false // Состояние завершения игры
//    @State private var isWin = false // Состояние победы
//    @State private var score = 0 // Счетчик очков
//    @State private var timeRemaining = 60 // Таймер на 1 минуту (60 секунд)
//    @State private var isPaused = false
//    @AppStorage("coinscore") var coinscore: Int = 10
//    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "background1"
//    
//    let timer = Timer.publish(every: Double.random(in: 2...3), on: .main, in: .common).autoconnect()
//    let gameTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Таймер для отсчета времени
//    
//    var body: some View {
//        ZStack {
//            GeometryReader { geometry in
//                    ZStack {
//                        VStack {
//                            HStack {
//                                Button(action: pauseGame) {
//                                    Image("pauseBtn")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 40, height: 40)
//                                        .foregroundStyle(.white)
//                                        .padding(10)
//                                }
//                                Spacer()
//                                TimeTemplate(time: timeRemaining)
//                                    .padding(.leading, 60)
//                                Spacer()
//                                BalanceTemplate()
//                                    .padding(.trailing, 2)
//                            }
//                            Spacer()
//                        }
//                        
//                        ForEach(nests.indices, id: \.self) { index in
//                            Image(index == 0 ? "nest" : index == 1 ? "forHel" : "forPlane")
//                                .resizable()
//                                .frame(
//                                    width: index == 2 ? 200 : 80, // Условие для ширины
//                                    height: 80 // Высота всегда 80
//                                )
//                                .position(nests[index])
//                        }
//                        
//                        
//                        ForEach(warnings) { warning in
//                            WarningView(warning: warning)
//                        }
//                        
//                        // Отображение столкновений
//                        ForEach(crashes) { crash in
//                            CrashView(crash: crash)
//                        }
//                        
//                        // Отображение объектов
//                        ForEach(objects) { object in
//                            if object.type == "bird" {
//                                BirdView(bird: object)
//                                    .gesture(
//                                        DragGesture()
//                                            .onChanged { value in
//                                                updatePath(for: object, location: value.location)
//                                            }
//                                            .onEnded { _ in
//                                                followPath(for: object)
//                                            }
//                                    )
//                            } else {
//                                StaticObjectView(object: object)
//                                    .gesture(
//                                        DragGesture()
//                                            .onChanged { value in
//                                                updatePath(for: object, location: value.location)
//                                            }
//                                            .onEnded { _ in
//                                                followPath(for: object)
//                                            }
//                                    )
//                            }
//                        }
//                        
//                        // Экраны окончания игры
//                        if isGameOver {
//                            if isWin {
//                                WinView { geometry in
//                                    resetGame(geometry: geometry)
//                                }
//                            } else {
//                                LoseView { geometry in
//                                    resetGame(geometry: geometry)
//                                }
//                            }
//                        }
//                        
//                        // Пауза
//                        if isPaused {
//                            PauseView(resumeAction: {
//                                isPaused = false
//                            })
//                        }
//                    }
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//                    .background(
//                        Image(currentSelectedCloseCard)
//                            .resizable()
//                            .scaledToFill()
//                            .edgesIgnoringSafeArea(.all)
//                            .scaleEffect(1.1)
//                    )
//                    .onAppear {
//                        placeNests(geometry: geometry)
//                    }
//                    .onReceive(timer) { _ in
//                        if !isGameOver && !isPaused {
//                            spawnObject(geometry: geometry)
//                        }
//                    }
//                    .onReceive(gameTimer) { _ in
//                        if !isGameOver && !isPaused {
//                            if timeRemaining > 0 {
//                                timeRemaining -= 1
//                            } else {
//                                isGameOver = true
//                                isWin = true
//                            }
//                        }
//                    }
//                    .onAppear {
//                        startObjectMovement(geometry: geometry)
//                    }
//            }
//        }
//    }
//    
//    func resetGame(geometry: GeometryProxy) {
//        timeRemaining = 60
//        isGameOver = false
//        isWin = false
//        score = 0
//        objects.removeAll()
//        warnings.removeAll()
//        crashes.removeAll()
//        placeNests(geometry: geometry)
//        startObjectMovement(geometry: geometry)
//    }
//    
//    func pauseGame() {
//        isPaused.toggle()
//    }
//    
//    func placeNests(geometry: GeometryProxy) {
//        nests = [
//            CGPoint(x: geometry.size.width * 0.25, y: geometry.size.height * 0.25), // nest
//            CGPoint(x: geometry.size.width * 0.75, y: geometry.size.height * 0.25), // forHel
//            CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.75)   // forPlane
//        ]
//    }
//    
//    func spawnObject(geometry: GeometryProxy) {
//        let side = Int.random(in: 0...2)
//        let startPosition: CGPoint
//        let targetPosition: CGPoint
//        let warningPosition: CGPoint
//        
//        switch side {
//        case 0: // Левая сторона
//            startPosition = CGPoint(x: -30, y: CGFloat.random(in: 0...geometry.size.height))
//            targetPosition = CGPoint(x: geometry.size.width / 2, y: CGFloat.random(in: 0...geometry.size.height))
//            warningPosition = CGPoint(x: -50, y: startPosition.y)
//        case 1: // Правая сторона
//            startPosition = CGPoint(x: geometry.size.width + 30, y: CGFloat.random(in: 0...geometry.size.height))
//            targetPosition = CGPoint(x: geometry.size.width / 2, y: CGFloat.random(in: 0...geometry.size.height))
//            warningPosition = CGPoint(x: geometry.size.width + 50, y: startPosition.y)
//        default: // Нижняя сторона
//            startPosition = CGPoint(x: CGFloat.random(in: 0...geometry.size.width), y: geometry.size.height + 30)
//            targetPosition = CGPoint(x: CGFloat.random(in: 0...geometry.size.width), y: geometry.size.height / 2)
//            warningPosition = CGPoint(x: startPosition.x, y: geometry.size.height + 50)
//        }
//        
//        let warning = Warning(position: warningPosition)
//        warnings.append(warning)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let objectType = ["bird", "hel1", "plane1"].randomElement()!
//            objects.append(GameObject(type: objectType, position: startPosition, target: targetPosition))
//            
//            if let index = warnings.firstIndex(where: { $0.id == warning.id }) {
//                warnings.remove(at: index)
//            }
//        }
//    }
//    
//    func startObjectMovement(geometry: GeometryProxy) {
//        DispatchQueue.global().async {
//            while !self.isGameOver {
//                if !self.isPaused {
//                    Thread.sleep(forTimeInterval: 0.04)
//                    
//                    var indicesToRemove: [Int] = []
//                    for i in self.objects.indices {
//                        let object = self.objects[i]
//                        if let updatedObject = self.updateObjectPosition(object: object, geometry: geometry) {
//                            self.objects[i] = updatedObject
//                        } else {
//                            indicesToRemove.append(i)
//                        }
//                    }
//                    
//                    withAnimation {
//                        for index in indicesToRemove.sorted(by: >) {
//                            self.objects.remove(at: index)
//                        }
//                    }
//                    
//                    self.checkForCollisions()
//                }
//            }
//        }
//    }
//    
//    func updateObjectPosition(object: GameObject, geometry: GeometryProxy) -> GameObject? {
//        if checkIfObjectReachedTarget(object: object) {
//            return nil
//        }
//        
//        if !object.path.isEmpty {
//            return moveAlongPath(object: object)
//        }
//        
//        let dx = object.target.x - object.position.x
//        let dy = object.target.y - object.position.y
//        let distance = sqrt(dx * dx + dy * dy)
//        
//        if distance < 5 {
//            return nil
//        } else {
//            let step = 2.0
//            let updatedPosition = CGPoint(
//                x: object.position.x + (dx / distance * step),
//                y: object.position.y + (dy / distance * step)
//            )
//            var updatedObject = object
//            updatedObject.position = updatedPosition
//            return updatedObject
//        }
//    }
//    
//    func moveAlongPath(object: GameObject) -> GameObject? {
//        guard !object.path.isEmpty else { return object }
//        let nextPoint = object.path[0]
//        let dx = nextPoint.x - object.position.x
//        let dy = nextPoint.y - object.position.y
//        let distance = sqrt(dx * dx + dy * dy)
//        
//        if distance < 5 {
//            var updatedObject = object
//            updatedObject.path.removeFirst()
//            return updatedObject
//        } else {
//            let step = 5.0
//            let updatedPosition = CGPoint(
//                x: object.position.x + (dx / distance * step),
//                y: object.position.y + (dy / distance * step)
//            )
//            var updatedObject = object
//            updatedObject.position = updatedPosition
//            return updatedObject
//        }
//    }
//    
//    func updatePath(for object: GameObject, location: CGPoint) {
//        if let index = objects.firstIndex(where: { $0.id == object.id }) {
//            var updatedObject = object
//            updatedObject.path.append(location)
//            objects[index] = updatedObject
//        }
//    }
//    
//    func followPath(for object: GameObject) {}
//    
//    func checkIfObjectReachedTarget(object: GameObject) -> Bool {
//        for (i, nest) in nests.enumerated() {
//            let dx = nest.x - object.position.x
//            let dy = nest.y - object.position.y
//            let distance = sqrt(dx * dx + dy * dy)
//            
//            if distance < 30 {
//                if (object.type == "bird" && i == 0) || // bird -> nest
//                   (object.type == "hel1" && i == 1) || // hel1 -> forHel
//                   (object.type == "plane1" && i == 2) { // plane1 -> forPlane
//                    coinscore += 10
//                    showCrashAt(position: object.position)
//                    return true
//                } else {
//                    isGameOver = true
//                    return true
//                }
//            }
//        }
//        return false
//    }
//    
//    func checkForCollisions() {
//        for i in 0..<objects.count {
//            for j in (i + 1)..<objects.count {
//                let obj1 = objects[i]
//                let obj2 = objects[j]
//                let dx = obj1.position.x - obj2.position.x
//                let dy = obj1.position.y - obj2.position.y
//                let distance = sqrt(dx * dx + dy * dy)
//                
//                if distance < 30 {
//                    isGameOver = true
//                    showCrashAt(position: obj1.position)
//                    print("Collision detected! Game Over.")
//                    return
//                }
//            }
//        }
//    }
//    
//    func showCrashAt(position: CGPoint) {
//        let crash = Crash(position: position)
//        crashes.append(crash)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if let index = self.crashes.firstIndex(where: { $0.id == crash.id }) {
//                self.crashes.remove(at: index)
//            }
//        }
//    }
//}
//
//// MARK: - BirdView
////struct BirdView: View {
////    @State private var currentFrame = 1
////    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard1: String = "frame"
////    let bird: GameObject
////
////    var body: some View {
////        ZStack {
////            Image("\(currentSelectedCloseCard1)\(currentFrame)")
////                .resizable()
////                .frame(width: 50, height: 50)
////                .position(bird.position)
////                .onAppear {
////                    startAnimation()
////                }
////                .overlay(
////                    Path { path in
////                        if let firstPoint = bird.path.first {
////                            path.move(to: firstPoint)
////                            for point in bird.path {
////                                path.addLine(to: point)
////                            }
////                        }
////                    }
////                    .stroke(Color.blue, lineWidth: 2)
////                )
////        }
////    }
////
////    func startAnimation() {
////        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
////            withAnimation(.linear(duration: 0.1)) {
////                currentFrame += 1
////                if currentFrame > 9 {
////                    currentFrame = 1
////                }
////            }
////        }
////    }
////}
//
//struct BirdView: View {
//    @State private var currentFrame = 1
//    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard1: String = "frame"
//    let bird: GameObject
//
//    var body: some View {
//        ZStack {
//            Image("\(currentSelectedCloseCard1)\(currentFrame)")
//                .resizable()
//                .frame(width: 50, height: 50)
//                .position(bird.position)
//                .onAppear {
//                    startAnimation() // Запускаем анимацию при появлении
//                }
//                .overlay(
//                    Path { path in
//                        if let firstPoint = bird.path.first {
//                            path.move(to: firstPoint)
//                            for point in bird.path {
//                                path.addLine(to: point)
//                            }
//                        }
//                    }
//                    .stroke(Color.blue, lineWidth: 2)
//                )
//                .animation(.linear(duration: 0.001), value: currentFrame)
//        }
//    }
//
//    func startAnimation() {
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            withAnimation(.linear(duration: 0.1)) {
//                currentFrame += 1 // Переходим к следующему фрейму
//                if currentFrame > 9 { // Если достигли последнего фрейма, возвращаемся к первому
//                    currentFrame = 1
//                }
//            }
//        }
//    }
//}
//
//// MARK: - StaticObjectView
//struct StaticObjectView: View {
//    let object: GameObject
//    
//    @AppStorage("currentSelectedCloseCard10") private var currentSelectedCloseCard10: String = "plane1"
//    
//    @AppStorage("currentSelectedCloseCard2") private var currentSelectedCloseCard2: String = "hel1"
//    
//    var body: some View {
//        ZStack {
//            Image(object.type == "plane1" ? currentSelectedCloseCard10 : currentSelectedCloseCard2)
//                .resizable()
//                .frame(width: 50, height: 50)
//                .position(object.position)
//                .overlay(
//                    Path { path in
//                        if let firstPoint = object.path.first {
//                            path.move(to: firstPoint)
//                            for point in object.path {
//                                path.addLine(to: point)
//                            }
//                        }
//                    }
//                    .stroke(Color.blue, lineWidth: 2)
//                )
//        }
//    }
//}
//
//// MARK: - GameObject
//struct GameObject: Identifiable {
//    let id = UUID()
//    let type: String
//    var position: CGPoint
//    var target: CGPoint
//    var path: [CGPoint] = []
//}
//
//// MARK: - Warning
//struct Warning: Identifiable {
//    let id = UUID()
//    let position: CGPoint
//}
//
//// MARK: - Crash
//struct Crash: Identifiable {
//    let id = UUID()
//    let position: CGPoint
//}
//
//// MARK: - GameObjectView
//
//
//
//struct WarningView: View {
//    let warning: Warning
//    
//    var body: some View {
//        Image("warning")
//            .resizable()
//            .frame(width: 50, height: 50)
//            .position(warning.position)
//    }
//}
//
//struct CrashView: View {
//    let crash: Crash
//    
//    var body: some View {
//        Image("crash")
//            .resizable()
//            .frame(width: 50, height: 50)
//            .position(crash.position)
//    }
//}
//
//struct Bird: Identifiable {
//    let id = UUID()
//    var position: CGPoint
//    var target: CGPoint
//    var path: [CGPoint] = [] // Для хранения траектории
//}
//
////struct Warning: Identifiable {
////    let id = UUID()
////    var position: CGPoint
////}
////
////struct Crash: Identifiable {
////    let id = UUID()
////    var position: CGPoint
////}
//
//struct TimeTemplate: View {
//    var time: Int
//    var body: some View {
//        ZStack {
//            Image(.timer)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 140, height: 70)
//                .overlay(
//                    ZStack {
//                        Text("\(time)")
//                            .foregroundColor(.white)
//                            .fontWeight(.heavy)
//                            .font(.title3)
//                            .position(x: 75, y: 35)
//                    }
//                )
//        }
//    }
//}
//
//struct PauseView: View {
//    var resumeAction: () -> Void
//
//    var body: some View {
//        ZStack {
//            Image(.pausePlate)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 250)
//                .frame(width: 380, height: 380)
// 
//            VStack(spacing: -40) {
//                Button(action: resumeAction) {
//                    Image(.resumeBtn)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 150, height: 90)
//                }
//                
//                Image(.menuBtn)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 150, height: 90)
//                    .onTapGesture {
//                        NavGuard.shared.currentScreen = .MENU
//                    }
//            }
//            .padding(.top, -5)
//        }
//    }
//}
//
//struct WinView: View {
//    var retryAction: (GeometryProxy) -> Void // Добавляем GeometryProxy в параметр
//    @AppStorage("level") var level: Int = 1 // Переменная для хранения текущего уровня
//    
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Image(.winPlate)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 380, height: 380)
//                    .padding(.top, 60)
//                
//                VStack(spacing: -40) {
//                    Image(.winText)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 120, height: 80)
//                    
//                    
//                    Button(action: {
//                        retryAction(geometry) // Передаем geometry в retryAction
//                        level += 1
//                    }) {
//                        Image(.nextLevelBtn)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 150, height: 90)
//                    }
//                    
//                    Image(.menuBtn)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 150, height: 90)
//                        .onTapGesture {
//                            NavGuard.shared.currentScreen = .MENU
//                            level += 1
//                        }
//                }
//                .padding(.top, 90)
//            }
//            .frame(width: geometry.size.width, height: geometry.size.height)
//        }
//    }
//}
//
//struct LoseView: View {
//    var retryAction: (GeometryProxy) -> Void
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Image(.losePlate)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 380, height: 380)
//                    .padding(.top, 60)
//                
//                VStack(spacing: -40) {
//                    
//                    Image(.loseText)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 120, height: 80)
//                    
//                    Button(action: {
//                        retryAction(geometry) // Передаем geometry в retryAction
//                    }) {
//                        Image(.retryBtn)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 150, height: 90)
//                    }
//                    
//                        Image(.menuBtn)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 150, height: 90)
//                            .onTapGesture {
//                                NavGuard.shared.currentScreen = .MENU
//                            }
//                }
//                .padding(.top, 50)
//            }
//            .frame(width: geometry.size.width, height: geometry.size.height)
//        }
//    }
//}
//
//#Preview {
//    MainGame()
//}
