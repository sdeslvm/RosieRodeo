import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var settings = CheckingSound()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                    
                    VStack(spacing: -20) {
                        HStack {
                            if settings.musicEnabled {
                                Image(.soundOn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 220, height: 150)
                                    .onTapGesture {
                                        settings.musicEnabled.toggle()
                                    }
                            } else {
                                Image(.soundOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 220, height: 150)
                                    .onTapGesture {
                                        settings.musicEnabled.toggle()
                                    }
                            }
                        }

                        Image(.langText)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 100)

                        HStack {
                            // English
                            if settings.enEnable {
                                Image(.enOn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 110)
                                    .onTapGesture {
                                        settings.enEnable = true
                                        settings.deEnable = false
                                        settings.frEnable = false
                                        settings.esEnable = false
                                    }
                            } else {
                                Image(.enOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 110)
                                    .onTapGesture {
                                        settings.enEnable = true
                                        settings.deEnable = false
                                        settings.frEnable = false
                                        settings.esEnable = false
                                    }
                            }

                            // German
                            if settings.deEnable {
                                Image(.deOn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 110)
                                    .onTapGesture {
                                        settings.enEnable = false
                                        settings.deEnable = true
                                        settings.frEnable = false
                                        settings.esEnable = false
                                    }
                            } else {
                                Image(.deOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 110)
                                    .onTapGesture {
                                        settings.enEnable = false
                                        settings.deEnable = true
                                        settings.frEnable = false
                                        settings.esEnable = false
                                    }
                            }

                            // French
                            if settings.frEnable {
                                Image(.frOn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 110)
                                    .onTapGesture {
                                        settings.enEnable = false
                                        settings.deEnable = false
                                        settings.frEnable = true
                                        settings.esEnable = false
                                    }
                            } else {
                                Image(.frOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 110)
                                    .onTapGesture {
                                        settings.enEnable = false
                                        settings.deEnable = false
                                        settings.frEnable = true
                                        settings.esEnable = false
                                    }
                            }

                            // Spanish
                            if settings.esEnable {
                                Image(.esOn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 110)
                                    .onTapGesture {
                                        settings.enEnable = false
                                        settings.deEnable = false
                                        settings.frEnable = false
                                        settings.esEnable = true
                                    }
                            } else {
                                Image(.esOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 110)
                                    .onTapGesture {
                                        settings.enEnable = false
                                        settings.deEnable = false
                                        settings.frEnable = false
                                        settings.esEnable = true
                                    }
                            }
                        }
                    }
                    .padding(.top, 30)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundSettings)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.05)
            )
        }
    }
}

extension SettingsView {
    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("error url: \(urlString)")
            }
        } else {
            print("error url: \(urlString)")
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Попробуем показать диалог с отзывом через StoreKit
            SKStoreReviewController.requestReview(in: scene)
        } else {
            print("error")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SoundManager.shared)
}


