import SwiftUI

/// アニメーション設定セクション
struct AnimationSection: View {
    @Binding var autoRotate: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: $autoRotate) {
                HStack(spacing: 8) {
                    Image(systemName: autoRotate ? "arrow.triangle.2.circlepath" : "arrow.triangle.2.circlepath")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(autoRotate ? ColorPalette.accent : ColorPalette.textMuted)
                        .symbolEffect(.rotate, options: .repeating, value: autoRotate)
                    
                    Text("Auto Rotate")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(ColorPalette.textPrimary)
                }
            }
            .toggleStyle(CustomToggleStyle())
        }
    }
}

/// カスタムトグルスタイル
struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        configuration.isOn
                            ? ColorPalette.accent
                            : ColorPalette.sliderTrack
                    )
                    .frame(width: 44, height: 24)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .shadow(color: ColorPalette.shadow.opacity(0.3), radius: 2, x: 0, y: 1)
                    .offset(x: configuration.isOn ? 10 : -10)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
