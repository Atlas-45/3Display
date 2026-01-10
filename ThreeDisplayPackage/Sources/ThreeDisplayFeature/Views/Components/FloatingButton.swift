import SwiftUI

/// 操作モード切り替え用フローティングボタン
struct FloatingActionButton: View {
    @Binding var isInteractionEnabled: Bool
    @Binding var position: CGPoint
    let onPositionChange: () -> Void
    let onHoverChange: (Bool) -> Void
    
    @State private var isDragging = false
    @State private var dragOffset: CGSize = .zero
    @State private var isHovered = false
    
    private let buttonSize: CGFloat = 48
    
    var body: some View {
        Button {
            if !isDragging {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isInteractionEnabled.toggle()
                }
            }
        } label: {
            ZStack {
                // 外側のグロー
                Circle()
                    .fill(ColorPalette.glow)
                    .frame(width: buttonSize + 16, height: buttonSize + 16)
                    .blur(radius: 8)
                    .opacity(isInteractionEnabled ? 0.8 : 0.3)
                
                // メインボタン
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isInteractionEnabled
                                ? [ColorPalette.accent, ColorPalette.accentDark]
                                : [ColorPalette.buttonSecondary, ColorPalette.panelBackground],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: buttonSize, height: buttonSize)
                    .overlay {
                        Circle()
                            .strokeBorder(
                                isInteractionEnabled
                                    ? ColorPalette.accentLight.opacity(0.5)
                                    : ColorPalette.border,
                                lineWidth: 1.5
                            )
                    }
                    .shadow(
                        color: isInteractionEnabled ? ColorPalette.glow : ColorPalette.shadow,
                        radius: isHovered ? 12 : 8,
                        x: 0,
                        y: 4
                    )
                
                // アイコン
                Image(systemName: isInteractionEnabled ? "hand.tap.fill" : "hand.tap")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(ColorPalette.textPrimary)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isDragging ? 1.1 : (isHovered ? 1.05 : 1.0))
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.2)) {
                isHovered = hovering
            }
            onHoverChange(hovering)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isInteractionEnabled)
        .help(isInteractionEnabled ? "Disable interaction (Option+Command+I)" : "Enable interaction (Option+Command+I)")
    }
}
