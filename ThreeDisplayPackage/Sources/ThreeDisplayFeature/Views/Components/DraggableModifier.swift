import SwiftUI

/// ドラッグで移動可能にするViewModifier
struct DraggableModifier: ViewModifier {
    @Binding var position: CGPoint
    let onDragEnd: (() -> Void)?
    
    @State private var isDragging = false
    @State private var dragOffset: CGSize = .zero
    
    init(position: Binding<CGPoint>, onDragEnd: (() -> Void)? = nil) {
        _position = position
        self.onDragEnd = onDragEnd
    }
    
    func body(content: Content) -> some View {
        content
            .position(
                x: position.x + (isDragging ? dragOffset.width : 0),
                y: position.y + (isDragging ? dragOffset.height : 0)
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        position.x += value.translation.width
                        position.y += value.translation.height
                        dragOffset = .zero
                        isDragging = false
                        onDragEnd?()
                    }
            )
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: isDragging)
    }
}

/// ドラッグハンドル付きコンテナ
struct DraggableContainer<Content: View>: View {
    @Binding var position: CGPoint
    let onDragEnd: (() -> Void)?
    @ViewBuilder let content: () -> Content
    
    @State private var isDragging = false
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        content()
            .position(
                x: position.x + (isDragging ? dragOffset.width : 0),
                y: position.y + (isDragging ? dragOffset.height : 0)
            )
    }
    
    func makeDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                dragOffset = value.translation
            }
            .onEnded { value in
                position.x += value.translation.width
                position.y += value.translation.height
                dragOffset = .zero
                isDragging = false
                onDragEnd?()
            }
    }
}

/// ドラッグ可能なヘッダー付きパネル
struct DraggablePanelHeader: View {
    let title: String
    @Binding var isMinimized: Bool
    let onClose: (() -> Void)?
    
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 8) {
            // ドラッグハンドル
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(ColorPalette.textMuted)
            
            Text(title)
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
                    .frame(width: 20, height: 20)
                    .background {
                        Circle()
                            .fill(ColorPalette.buttonSecondary.opacity(isHovered ? 1 : 0))
                    }
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                isHovered = hovering
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(ColorPalette.sectionBackground)
        .contentShape(Rectangle())
    }
}

extension View {
    func draggable(position: Binding<CGPoint>, onDragEnd: (() -> Void)? = nil) -> some View {
        modifier(DraggableModifier(position: position, onDragEnd: onDragEnd))
    }
}
