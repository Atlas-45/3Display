import SwiftUI

/// 変形設定セクション（方向・強度）
struct TransformSection: View {
    @Binding var directionAngle: Double
    @Binding var strength: Double
    
    var body: some View {
        VStack(spacing: 16) {
            CustomSlider(
                title: "Direction",
                value: $directionAngle,
                range: -180...180,
                step: 1,
                valueFormatter: { String(format: "%.0f°", $0) }
            )
            
            CustomSlider(
                title: "Strength",
                value: $strength,
                range: 0...1.5,
                step: 0.01,
                valueFormatter: { String(format: "%.2f", $0) }
            )
        }
    }
}
