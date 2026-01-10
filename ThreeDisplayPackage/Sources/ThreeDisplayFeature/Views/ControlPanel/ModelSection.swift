import SwiftUI

/// モデル設定セクション
struct ModelSection: View {
    let modelName: String
    let onLoadModel: () -> Void
    let onResetModel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // ボタン行
            HStack(spacing: 8) {
                Button {
                    onLoadModel()
                } label: {
                    Label("Load USDZ", systemImage: "doc.badge.plus")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button {
                    onResetModel()
                } label: {
                    Label("Use Box", systemImage: "cube")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            
            // 現在のモデル名
            HStack(spacing: 6) {
                Image(systemName: "cube.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(ColorPalette.accent)
                
                Text(modelName)
                    .font(.system(size: 11))
                    .foregroundStyle(ColorPalette.textSecondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(ColorPalette.sectionBackground)
            }
        }
    }
}
