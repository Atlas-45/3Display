import SwiftUI

/// パネル用のスタイル（グラス効果、角丸、影）
struct PanelStyle: ViewModifier {
    var cornerRadius: CGFloat = 16
    var showShadow: Bool = true
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .background {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(ColorPalette.panelBackground)
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(ColorPalette.border, lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: showShadow ? ColorPalette.shadow : .clear, radius: 20, x: 0, y: 10)
    }
}

/// セクション用のスタイル
struct SectionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(ColorPalette.sectionBackground)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(ColorPalette.divider, lineWidth: 1)
            }
    }
}

extension View {
    func panelStyle(cornerRadius: CGFloat = 16, showShadow: Bool = true) -> some View {
        modifier(PanelStyle(cornerRadius: cornerRadius, showShadow: showShadow))
    }
    
    func sectionStyle() -> some View {
        modifier(SectionStyle())
    }
}
