import SwiftUI

/// メインコントロールパネル
struct ControlPanelView: View {
    let modelName: String
    @Binding var directionAngle: Double
    @Binding var strength: Double
    @Binding var autoRotate: Bool
    @Binding var position: CGPoint
    @Binding var isMinimized: Bool
    
    let onLoadModel: () -> Void
    let onResetModel: () -> Void
    let onPositionChange: () -> Void
    
    @State private var isModelExpanded = true
    @State private var isTransformExpanded = true
    @State private var isAnimationExpanded = true
    
    private let panelWidth: CGFloat = 300
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            headerView
            
            // コンテンツ（折りたたみ可能）
            if !isMinimized {
                VStack(spacing: 0) {
                    SectionDivider()
                    
                    CollapsibleSection(
                        title: "Model",
                        icon: "cube.fill",
                        isExpanded: $isModelExpanded
                    ) {
                        ModelSection(
                            modelName: modelName,
                            onLoadModel: onLoadModel,
                            onResetModel: onResetModel
                        )
                    }
                    
                    SectionDivider()
                    
                    CollapsibleSection(
                        title: "Transform",
                        icon: "move.3d",
                        isExpanded: $isTransformExpanded
                    ) {
                        TransformSection(
                            directionAngle: $directionAngle,
                            strength: $strength
                        )
                    }
                    
                    SectionDivider()
                    
                    CollapsibleSection(
                        title: "Animation",
                        icon: "play.circle.fill",
                        isExpanded: $isAnimationExpanded
                    ) {
                        AnimationSection(autoRotate: $autoRotate)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .frame(width: panelWidth)
        .panelStyle()
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isMinimized)
    }
    
    private var headerView: some View {
        HStack(spacing: 8) {
            // ドラッグインジケーター
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(ColorPalette.textMuted)
            
            Text("Controls")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(ColorPalette.textPrimary)
            
            Spacer()
            
            // 最小化ボタン
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isMinimized.toggle()
                }
            } label: {
                Image(systemName: isMinimized ? "chevron.down" : "chevron.up")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(ColorPalette.textSecondary)
                    .frame(width: 24, height: 24)
                    .background {
                        Circle()
                            .fill(ColorPalette.buttonSecondary.opacity(0.5))
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(ColorPalette.sectionBackground.opacity(0.5))
        .contentShape(Rectangle())
    }
}
