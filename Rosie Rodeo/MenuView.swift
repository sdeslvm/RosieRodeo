import SwiftUI

struct MenuView: View {
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                
                
                
                VStack {
                    ButtonTemplateBig(image: "playBtn", action: {NavGuard.shared.currentScreen = .LEVELS})
                    ButtonTemplateBig(image: "shopBtn", action: {NavGuard.shared.currentScreen = .SHOP})
                    ButtonTemplateBig(image: "achiveBtn", action: {NavGuard.shared.currentScreen = .ACHIVE})
                    
                    ButtonTemplateBig(image: "settingsBtn", action: {NavGuard.shared.currentScreen = .SETTINGS})
                }
                .padding(.top, 250)
                
                
              
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )

        }
    }
}



struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    
    var body: some View {
        ZStack {
            Image("balanceTemplate")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(coinscore)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 65, y: 33)
                    }
                )
        }
    }
}



struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateBig: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}



#Preview {
    MenuView()
}

