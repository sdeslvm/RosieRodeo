import SwiftUI

// Модель данных для карты
struct CardOption: Identifiable {
    let id: String
    let buyImage: String
    let selectImage: String
    let closeImage: String
    let selectedImage: String
}

// Первая страница магазина
struct ShopPageOne: View {
    @Binding var playerBalance: Int
    @State private var currentCardIndex: Int = 0

    @AppStorage("ownedCards1") private var ownedCards1: String = "pers1"
    @AppStorage("selectedCard1") private var selectedCard1: String = "firstCardSelected"
    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard1: String = "coin1"

    @State private var alertMessage: String?
    @State private var showAlert: Bool = false
    
    private let cardOptions: [CardOption] = [
        CardOption(id: "firstCard1", buyImage: "firstCardBuy1", selectImage: "firstCardSelect1", closeImage: "pers1", selectedImage: "firstCardSelected1"),
        CardOption(id: "secondCard1", buyImage: "secondCardBuy1", selectImage: "secondCardSelect1", closeImage: "pers2", selectedImage: "secondCardSelected1"),
        CardOption(id: "thirdCard1", buyImage: "thirdCardBuy1", selectImage: "thirdCardSelect1", closeImage: "pers3", selectedImage: "thirdCardSelected1")
    ]

    private let cardPrice: Int = 500

    var body: some View {
        HStack {
            // Кнопка влево
            Button(action: {
                withAnimation {
                    currentCardIndex = (currentCardIndex - 1 + cardOptions.count) % cardOptions.count
                }
            }) {
                Image("left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            
            // Центральная карточка
            Button(action: {
                handleCardAction(for: cardOptions[currentCardIndex])
            }) {
                Image(currentImage(for: cardOptions[currentCardIndex]))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 310)
            }
            
            // Кнопка вправо
            Button(action: {
                withAnimation {
                    currentCardIndex = (currentCardIndex + 1) % cardOptions.count
                }
            }) {
                Image("right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        }
        .onAppear {
            print("ShopPageOne appeared")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func currentImage(for card: CardOption) -> String {
        if card.selectedImage == selectedCard1 {
            return card.selectedImage
        } else if ownedCards1.contains(card.closeImage) {
            return card.selectImage
        } else {
            return card.buyImage
        }
    }

    private func handleCardAction(for card: CardOption) {
        print("ShopPageOne: Handling action for \(card.id), ownedCards: \(ownedCards1), balance: \(playerBalance)")
        if ownedCards1.contains(card.closeImage) {
            selectedCard1 = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage)
            alertMessage = "Card selected successfully!"
        } else if playerBalance >= cardPrice {
            playerBalance -= cardPrice
            ownedCards1 += ownedCards1.isEmpty ? card.closeImage : ",\(card.closeImage)"
            selectedCard1 = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage)
            alertMessage = "Card purchased successfully!"
        } else {
            alertMessage = "Not enough coins to buy this card!"
        }
        showAlert = true
    }

    private func saveCurrentSelectedCloseCard(_ closeCard: String) {
        currentSelectedCloseCard1 = closeCard
    }
}

// Вторая страница магазина
struct ShopPageTwo: View {
    @Binding var playerBalance: Int

    @AppStorage("ownedCards") private var ownedCards: String = "background1"
    @AppStorage("selectedCard") private var selectedCard: String = "firstCardSelected"
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard1: String = "background1"

    @State private var alertMessage: String?
    @State private var showAlert: Bool = false
    
    private let cardOptions: [CardOption] = [
        CardOption(id: "firstCard2", buyImage: "firstCardBuy2", selectImage: "firstCardSelect2", closeImage: "background1", selectedImage: "firstCardSelected2"),
        CardOption(id: "secondCard2", buyImage: "secondCardBuy2", selectImage: "secondCardSelect2", closeImage: "background2", selectedImage: "secondCardSelected2"),
        CardOption(id: "thirdCard2", buyImage: "thirdCardBuy2", selectImage: "thirdCardSelect2", closeImage: "background3", selectedImage: "thirdCardSelected2"),
        CardOption(id: "fourCard2", buyImage: "fourCardBuy2", selectImage: "fourCardSelect2", closeImage: "background4", selectedImage: "fourCardSelected2")
    ]

    private let cardPrice: Int = 500

    var body: some View {
        VStack(spacing: 20) {
            // Первый ряд (карточки 1 и 2)
            HStack(spacing: 20) {
                ForEach(0..<2) { index in
                    Button(action: {
                        handleCardAction(for: cardOptions[index])
                    }) {
                        Image(currentImage(for: cardOptions[index]))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 210)
                    }
                }
            }
            
            // Второй ряд (карточки 3 и 4)
            HStack(spacing: 20) {
                ForEach(2..<4) { index in
                    Button(action: {
                        handleCardAction(for: cardOptions[index])
                    }) {
                        Image(currentImage(for: cardOptions[index]))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 210)
                    }
                }
            }
        }
        .onAppear {
            print("ShopPageTwo appeared")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func currentImage(for card: CardOption) -> String {
        if card.selectedImage == selectedCard {
            return card.selectedImage
        } else if ownedCards.contains(card.closeImage) {
            return card.selectImage
        } else {
            return card.buyImage
        }
    }

    private func handleCardAction(for card: CardOption) {
        if ownedCards.contains(card.closeImage) {
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard1(card.closeImage)
            alertMessage = "Card selected successfully!"
        } else if playerBalance >= cardPrice {
            playerBalance -= cardPrice
            ownedCards += ownedCards.isEmpty ? card.closeImage : ",\(card.closeImage)"
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard1(card.closeImage)
            alertMessage = "Card purchased successfully!"
        } else {
            alertMessage = "Not enough coins to buy this card!"
        }
        showAlert = true
    }

    private func saveCurrentSelectedCloseCard1(_ closeCard: String) {
        currentSelectedCloseCard1 = closeCard
        print("ShopPageTwo: Saved currentSelectedCloseCard1: \(currentSelectedCloseCard1)")
    }
}

struct ShopPageThree: View {
    @Binding var playerBalance: Int

    @AppStorage("ownedCards2") private var ownedCards: String = "background1"
    @AppStorage("selectedCard2") private var selectedCard: String = "firstCardSelected"
    @AppStorage("currentSelectedCloseCard2") private var currentSelectedCloseCard1: String = "background1"

    @State private var alertMessage: String?
    @State private var showAlert: Bool = false
    
    private let cardOptions: [CardOption] = [
        CardOption(id: "firstCard3", buyImage: "firstCardBuy3", selectImage: "firstCardSelect3", closeImage: "sky1", selectedImage: "firstCardSelected3"),
        CardOption(id: "secondCard3", buyImage: "secondCardBuy3", selectImage: "secondCardSelect3", closeImage: "sky2", selectedImage: "secondCardSelected3"),
        CardOption(id: "thirdCard3", buyImage: "thirdCardBuy3", selectImage: "thirdCardSelect3", closeImage: "sky3", selectedImage: "thirdCardSelected3"),
        CardOption(id: "fourCard3", buyImage: "fourCardBuy3", selectImage: "fourCardSelect3", closeImage: "sky4", selectedImage: "fourCardSelected3")
    ]

    private let cardPrice: Int = 500

    var body: some View {
        VStack(spacing: 20) {
            // Первый ряд (карточки 1 и 2)
            HStack(spacing: 20) {
                ForEach(0..<2) { index in
                    Button(action: {
                        handleCardAction(for: cardOptions[index])
                    }) {
                        Image(currentImage(for: cardOptions[index]))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 210)
                    }
                }
            }
            
            // Второй ряд (карточки 3 и 4)
            HStack(spacing: 20) {
                ForEach(2..<4) { index in
                    Button(action: {
                        handleCardAction(for: cardOptions[index])
                    }) {
                        Image(currentImage(for: cardOptions[index]))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 210)
                    }
                }
            }
        }
        .onAppear {
            print("ShopPageTwo appeared")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func currentImage(for card: CardOption) -> String {
        if card.selectedImage == selectedCard {
            return card.selectedImage
        } else if ownedCards.contains(card.closeImage) {
            return card.selectImage
        } else {
            return card.buyImage
        }
    }

    private func handleCardAction(for card: CardOption) {
        if ownedCards.contains(card.closeImage) {
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard1(card.closeImage)
            alertMessage = "Card selected successfully!"
        } else if playerBalance >= cardPrice {
            playerBalance -= cardPrice
            ownedCards += ownedCards.isEmpty ? card.closeImage : ",\(card.closeImage)"
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard1(card.closeImage)
            alertMessage = "Card purchased successfully!"
        } else {
            alertMessage = "Not enough coins to buy this card!"
        }
        showAlert = true
    }

    private func saveCurrentSelectedCloseCard1(_ closeCard: String) {
        currentSelectedCloseCard1 = closeCard
        print("ShopPageTwo: Saved currentSelectedCloseCard1: \(currentSelectedCloseCard1)")
    }
}

// Основной экран магазина
struct ShopView: View {
    @State private var currentGroupIndex: Int = 0
    @AppStorage("coinscore") private var playerBalance: Int = 20 // Начальный баланс 20 для теста

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
                        BalanceTemplate()
                    }
                    Spacer()
                }
                
                    
                VStack {
                    HStack {
                        Image(currentGroupIndex == 0 ? "cowboyOn" :  "cowboyOff")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .onTapGesture {
                                    currentGroupIndex = max(0, currentGroupIndex - 1)
                            }
                        
                        Image(currentGroupIndex == 1 ? "locationOn" :  "locationOff")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .onTapGesture {

                                    currentGroupIndex = min(1, currentGroupIndex + 1)
                            
                            }
                        
                        Image(currentGroupIndex == 2 ? "effectsOn" :  "effectsOff")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .onTapGesture {

                                    currentGroupIndex = min(2, currentGroupIndex + 1)
                            
                            }
                        
                    }
                    .padding(.top, 40)
                    Spacer()
                }

                VStack {

                    if currentGroupIndex == 0 {
                        ShopPageOne(playerBalance: $playerBalance)
                    }
                    if currentGroupIndex == 1 {   ShopPageTwo(playerBalance: $playerBalance)
                    }
                    if currentGroupIndex == 2 {
                        ShopPageThree(playerBalance: $playerBalance)
                    }
                    
                    
                }
                .padding(.top, 80)
                
               
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundShop) // Предполагается, что это имя изображения
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
        .onAppear {
            print("ShopView appeared with balance: \(playerBalance)")
        }
    }
}


#Preview {
    ShopView()
}
