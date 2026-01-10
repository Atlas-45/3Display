import SwiftUI

/// アプリ全体で使用するカラーパレット
public enum ColorPalette {
    // MARK: - Primary (ダークティール系)
    
    /// メインアクセントカラー
    static let accent = Color(nsColor: NSColor(calibratedRed: 0.1, green: 0.6, blue: 0.7, alpha: 1.0))
    
    /// アクセント明るめ
    static let accentLight = Color(nsColor: NSColor(calibratedRed: 0.2, green: 0.75, blue: 0.85, alpha: 1.0))
    
    /// アクセント暗め
    static let accentDark = Color(nsColor: NSColor(calibratedRed: 0.05, green: 0.4, blue: 0.5, alpha: 1.0))
    
    // MARK: - Background
    
    /// パネル背景（半透明ダーク）
    static let panelBackground = Color(nsColor: NSColor(calibratedWhite: 0.1, alpha: 0.85))
    
    /// パネル背景（ホバー時）
    static let panelBackgroundHover = Color(nsColor: NSColor(calibratedWhite: 0.15, alpha: 0.9))
    
    /// セクション背景
    static let sectionBackground = Color(nsColor: NSColor(calibratedWhite: 0.08, alpha: 0.6))
    
    // MARK: - Text
    
    /// プライマリテキスト
    static let textPrimary = Color(nsColor: NSColor(calibratedWhite: 0.95, alpha: 1.0))
    
    /// セカンダリテキスト
    static let textSecondary = Color(nsColor: NSColor(calibratedWhite: 0.7, alpha: 1.0))
    
    /// 淡いテキスト
    static let textMuted = Color(nsColor: NSColor(calibratedWhite: 0.5, alpha: 1.0))
    
    // MARK: - Border & Divider
    
    /// ボーダー色
    static let border = Color(nsColor: NSColor(calibratedWhite: 1.0, alpha: 0.12))
    
    /// ボーダー色（強調）
    static let borderStrong = Color(nsColor: NSColor(calibratedWhite: 1.0, alpha: 0.25))
    
    /// 区切り線
    static let divider = Color(nsColor: NSColor(calibratedWhite: 1.0, alpha: 0.08))
    
    // MARK: - Interactive
    
    /// ボタン背景
    static let buttonBackground = Color(nsColor: NSColor(calibratedRed: 0.1, green: 0.6, blue: 0.7, alpha: 0.8))
    
    /// ボタン背景（ホバー）
    static let buttonBackgroundHover = Color(nsColor: NSColor(calibratedRed: 0.15, green: 0.65, blue: 0.75, alpha: 0.9))
    
    /// ボタン背景（押下）
    static let buttonBackgroundPressed = Color(nsColor: NSColor(calibratedRed: 0.08, green: 0.5, blue: 0.6, alpha: 1.0))
    
    /// セカンダリボタン背景
    static let buttonSecondary = Color(nsColor: NSColor(calibratedWhite: 0.2, alpha: 0.7))
    
    /// セカンダリボタン背景（ホバー）
    static let buttonSecondaryHover = Color(nsColor: NSColor(calibratedWhite: 0.25, alpha: 0.8))
    
    // MARK: - Slider
    
    /// スライダートラック
    static let sliderTrack = Color(nsColor: NSColor(calibratedWhite: 0.3, alpha: 0.5))
    
    /// スライダー進捗
    static let sliderProgress = accent
    
    /// スライダーつまみ
    static let sliderThumb = Color.white
    
    // MARK: - Shadow
    
    /// ドロップシャドウ
    static let shadow = Color.black.opacity(0.4)
    
    /// グロー効果
    static let glow = Color(nsColor: NSColor(calibratedRed: 0.2, green: 0.7, blue: 0.8, alpha: 0.3))
}
