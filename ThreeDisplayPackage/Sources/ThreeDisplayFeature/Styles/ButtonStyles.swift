import SwiftUI

/// プライマリボタンスタイル（ティール系）
struct PrimaryButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(ColorPalette.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        configuration.isPressed
                            ? ColorPalette.buttonBackgroundPressed
                            : (isHovered ? ColorPalette.buttonBackgroundHover : ColorPalette.buttonBackground)
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(ColorPalette.accentLight.opacity(0.3), lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

/// セカンダリボタンスタイル（グレー系）
struct SecondaryButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(ColorPalette.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        configuration.isPressed
                            ? ColorPalette.buttonSecondary
                            : (isHovered ? ColorPalette.buttonSecondaryHover : ColorPalette.buttonSecondary)
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(ColorPalette.border, lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

/// アイコンボタンスタイル（丸型）
struct IconButtonStyle: ButtonStyle {
    var size: CGFloat = 36
    var isPrimary: Bool = true
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: size * 0.45, weight: .semibold))
            .foregroundStyle(ColorPalette.textPrimary)
            .frame(width: size, height: size)
            .background {
                Circle()
                    .fill(
                        isPrimary
                            ? (configuration.isPressed ? ColorPalette.buttonBackgroundPressed : (isHovered ? ColorPalette.buttonBackgroundHover : ColorPalette.buttonBackground))
                            : (configuration.isPressed ? ColorPalette.buttonSecondary : (isHovered ? ColorPalette.buttonSecondaryHover : ColorPalette.buttonSecondary))
                    )
            }
            .overlay {
                Circle()
                    .strokeBorder(
                        isPrimary ? ColorPalette.accentLight.opacity(0.3) : ColorPalette.border,
                        lineWidth: 1
                    )
            }
            .shadow(color: isPrimary ? ColorPalette.glow : .clear, radius: isHovered ? 8 : 4, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.92 : (isHovered ? 1.05 : 1.0))
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle { SecondaryButtonStyle() }
}
