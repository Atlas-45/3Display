import SwiftUI

/// アプリ全体の設定を管理するクラス
public final class OverlaySettings: ObservableObject {
    // MARK: - Published Properties
    
    @Published public var allowsInteraction: Bool {
        didSet { save() }
    }
    
    @Published public var panelPosition: CGPoint {
        didSet { save() }
    }
    
    @Published public var floatingButtonPosition: CGPoint {
        didSet { save() }
    }
    
    @Published public var isPanelMinimized: Bool {
        didSet { save() }
    }
    
    @Published public var directionAngle: Double {
        didSet { save() }
    }
    
    @Published public var strength: Double {
        didSet { save() }
    }
    
    @Published public var autoRotate: Bool {
        didSet { save() }
    }
    
    // MARK: - UserDefaults Keys
    
    private enum Keys {
        static let allowsInteraction = "allowsInteraction"
        static let panelPositionX = "panelPositionX"
        static let panelPositionY = "panelPositionY"
        static let floatingButtonPositionX = "floatingButtonPositionX"
        static let floatingButtonPositionY = "floatingButtonPositionY"
        static let isPanelMinimized = "isPanelMinimized"
        static let directionAngle = "directionAngle"
        static let strength = "strength"
        static let autoRotate = "autoRotate"
        static let hasLaunchedBefore = "hasLaunchedBefore"
    }
    
    // MARK: - Default Values
    
    private static let defaultPanelPosition = CGPoint(x: 40, y: 120)
    private static let defaultFloatingButtonPosition = CGPoint(x: -80, y: -80) // 右下からのオフセット
    private static let defaultDirectionAngle: Double = 15
    private static let defaultStrength: Double = 0.8
    
    // MARK: - Initialization
    
    public init() {
        let defaults = UserDefaults.standard
        let hasLaunchedBefore = defaults.bool(forKey: Keys.hasLaunchedBefore)
        
        if hasLaunchedBefore {
            // 保存された値を復元
            self.allowsInteraction = defaults.bool(forKey: Keys.allowsInteraction)
            self.panelPosition = CGPoint(
                x: defaults.double(forKey: Keys.panelPositionX),
                y: defaults.double(forKey: Keys.panelPositionY)
            )
            self.floatingButtonPosition = CGPoint(
                x: defaults.double(forKey: Keys.floatingButtonPositionX),
                y: defaults.double(forKey: Keys.floatingButtonPositionY)
            )
            self.isPanelMinimized = defaults.bool(forKey: Keys.isPanelMinimized)
            self.directionAngle = defaults.double(forKey: Keys.directionAngle)
            self.strength = defaults.double(forKey: Keys.strength)
            self.autoRotate = defaults.bool(forKey: Keys.autoRotate)
            
            // 位置が0,0の場合はデフォルト値を使用
            if self.panelPosition == .zero {
                self.panelPosition = Self.defaultPanelPosition
            }
            if self.floatingButtonPosition == .zero {
                self.floatingButtonPosition = Self.defaultFloatingButtonPosition
            }
        } else {
            // 初回起動時のデフォルト値
            self.allowsInteraction = false
            self.panelPosition = Self.defaultPanelPosition
            self.floatingButtonPosition = Self.defaultFloatingButtonPosition
            self.isPanelMinimized = false
            self.directionAngle = Self.defaultDirectionAngle
            self.strength = Self.defaultStrength
            self.autoRotate = true
            
            // 初回起動フラグを設定
            defaults.set(true, forKey: Keys.hasLaunchedBefore)
        }
    }
    
    // MARK: - Persistence
    
    private func save() {
        let defaults = UserDefaults.standard
        defaults.set(allowsInteraction, forKey: Keys.allowsInteraction)
        defaults.set(panelPosition.x, forKey: Keys.panelPositionX)
        defaults.set(panelPosition.y, forKey: Keys.panelPositionY)
        defaults.set(floatingButtonPosition.x, forKey: Keys.floatingButtonPositionX)
        defaults.set(floatingButtonPosition.y, forKey: Keys.floatingButtonPositionY)
        defaults.set(isPanelMinimized, forKey: Keys.isPanelMinimized)
        defaults.set(directionAngle, forKey: Keys.directionAngle)
        defaults.set(strength, forKey: Keys.strength)
        defaults.set(autoRotate, forKey: Keys.autoRotate)
    }
    
    // MARK: - Helpers
    
    /// 設定をリセット
    public func reset() {
        allowsInteraction = false
        panelPosition = Self.defaultPanelPosition
        floatingButtonPosition = Self.defaultFloatingButtonPosition
        isPanelMinimized = false
        directionAngle = Self.defaultDirectionAngle
        strength = Self.defaultStrength
        autoRotate = true
    }
}
