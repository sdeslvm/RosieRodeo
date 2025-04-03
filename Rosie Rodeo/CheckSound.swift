import Foundation
import SwiftUI

class CheckingSound: ObservableObject {
    @AppStorage("musicEnabled") var musicEnabled: Bool = false {
        didSet {
            SoundManager.shared.isSoundOn = musicEnabled
        }
    }
    @AppStorage("deEnable") var soundEnabled: Bool = true
    @AppStorage("enEnable") var enEnable: Bool = true
    @AppStorage("deEnable") var deEnable: Bool = true
    @AppStorage("frEnable") var frEnable: Bool = true
    @AppStorage("esEnable") var esEnable: Bool = true
}
