import Foundation


enum AvailableScreens {
    case MENU
    case LEVELS
    case SETTINGS
    case SHOP
    case ACHIVE
    case GAME
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .MENU
    static var shared: NavGuard = .init()
}
