import SwiftUI

/// カスタムスライダービュー
struct CustomSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let valueFormatter: (Double) -> String
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(ColorPalette.textSecondary)
                
                Spacer()
                
                Text(valueFormatter(value))
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(isEditing ? ColorPalette.accent : ColorPalette.textPrimary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // トラック背景
                    RoundedRectangle(cornerRadius: 3)
                        .fill(ColorPalette.sliderTrack)
                        .frame(height: 6)
                    
                    // 進捗部分
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [ColorPalette.accentDark, ColorPalette.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: progressWidth(in: geometry.size.width), height: 6)
                    
                    // つまみ
                    Circle()
                        .fill(ColorPalette.sliderThumb)
                        .frame(width: 16, height: 16)
                        .shadow(color: ColorPalette.shadow.opacity(0.5), radius: 3, x: 0, y: 2)
                        .overlay {
                            Circle()
                                .fill(ColorPalette.accent)
                                .frame(width: 8, height: 8)
                                .opacity(isEditing ? 1 : 0)
                                .scaleEffect(isEditing ? 1 : 0.5)
                        }
                        .offset(x: thumbOffset(in: geometry.size.width))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    isEditing = true
                                    updateValue(from: gesture.location.x, in: geometry.size.width)
                                }
                                .onEnded { _ in
                                    isEditing = false
                                }
                        )
                }
                .frame(height: 16)
            }
            .frame(height: 16)
        }
        .animation(.easeOut(duration: 0.15), value: isEditing)
    }
    
    private func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return max(0, min(totalWidth, CGFloat(progress) * totalWidth))
    }
    
    private func thumbOffset(in totalWidth: CGFloat) -> CGFloat {
        let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return max(0, min(totalWidth - 16, CGFloat(progress) * (totalWidth - 16)))
    }
    
    private func updateValue(from x: CGFloat, in totalWidth: CGFloat) {
        let clampedX = max(0, min(totalWidth, x))
        let progress = clampedX / totalWidth
        var newValue = range.lowerBound + Double(progress) * (range.upperBound - range.lowerBound)
        
        if let step {
            newValue = (newValue / step).rounded() * step
        }
        
        value = max(range.lowerBound, min(range.upperBound, newValue))
    }
}
