import AppKit
import SwiftUI
import UniformTypeIdentifiers

public struct ContentView: View {
    @StateObject private var faceTracker = FaceTrackingManager()
    @ObservedObject private var settings: OverlaySettings

    public init(settings: OverlaySettings = OverlaySettings()) {
        _settings = ObservedObject(wrappedValue: settings)
    }

    public var body: some View {
        ZStack {
            // 背景色（デバッグ用 - 後で透明に）
            Color.black.opacity(0.3)
            
            // 3D コンテンツ
            SceneKitOverlayView(
                facePosition: faceTracker.facePosition,
                depthEffect: settings.strength,
                autoRotate: settings.autoRotate
            )
            
            // UI オーバーレイ
            VStack {
                // 上部：顔追跡ステータス
                HStack {
                    // ステータスインジケーター
                    HStack(spacing: 8) {
                        Circle()
                            .fill(faceTracker.isFaceDetected ? Color.green : Color.red)
                            .frame(width: 10, height: 10)
                        
                        Text(faceTracker.isFaceDetected ? "Face Detected" : "No Face")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    // 顔位置デバッグ表示
                    if faceTracker.isFaceDetected {
                        Text(String(format: "X: %.2f  Y: %.2f", faceTracker.facePosition.x, faceTracker.facePosition.y))
                            .font(.caption.monospaced())
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Spacer()
                
                // 下部：コントロール
                HStack(alignment: .bottom) {
                    // 左下：設定パネル（allowsInteraction時のみ）
                    if settings.allowsInteraction {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Controls")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading) {
                                Text("Depth Effect: \(String(format: "%.1f", settings.strength))")
                                    .foregroundColor(.white)
                                Slider(value: $settings.strength, in: 0...5)
                                    .frame(width: 200)
                            }
                            
                            Toggle("Auto Rotate", isOn: $settings.autoRotate)
                                .foregroundColor(.white)
                            
                            // トラッキング制御
                            HStack {
                                Button(action: {
                                    if faceTracker.isTracking {
                                        faceTracker.stopTracking()
                                    } else {
                                        faceTracker.startTracking()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: faceTracker.isTracking ? "video.slash" : "video")
                                        Text(faceTracker.isTracking ? "Stop Tracking" : "Start Tracking")
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(faceTracker.isTracking ? Color.red : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            if let error = faceTracker.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                        .padding()
                    }
                    
                    Spacer()
                    
                    // 右下：インタラクションボタン
                    Button(action: {
                        settings.allowsInteraction.toggle()
                    }) {
                        Circle()
                            .fill(settings.allowsInteraction ? Color.green : Color.gray)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Image(systemName: "hand.tap")
                                    .foregroundColor(.white)
                                    .font(.title2)
                            }
                    }
                    .buttonStyle(.plain)
                    .padding(30)
                }
            }
        }
        .onAppear {
            // 自動的にトラッキング開始
            faceTracker.startTracking()
        }
        .onDisappear {
            faceTracker.stopTracking()
        }
    }
}
