import AppKit
import SwiftUI

public struct ContentView: View {
    @StateObject private var sceneController = SceneGraphController()
    @StateObject private var faceTracker = FaceTrackingManager()
    @State private var didConfigureWindow = false
    @State private var selectedModel: SampleModel = .proceduralCube
    @State private var useFaceTracking = false

    public init() {}

    public var body: some View {
        ZStack(alignment: .topLeading) {
            SceneKitOverlayView(controller: sceneController)
                .ignoresSafeArea()

            controlPanel
                .padding()
                .frame(maxWidth: 360)

            WindowAccessor { window in
                guard let window, !didConfigureWindow else { return }
                configureOverlayWindow(window)
                didConfigureWindow = true
            }
        }
        .onChange(of: useFaceTracking) { enabled in
            if enabled {
                faceTracker.start()
            } else {
                faceTracker.stop()
                sceneController.updateCameraOffset(.zero)
            }
            sceneController.faceTrackingEnabled = enabled
        }
        .onChange(of: faceTracker.normalizedFaceOffset) { offset in
            guard useFaceTracking else { return }
            sceneController.updateCameraOffset(offset)
        }
        .onAppear {
            sceneController.load(model: selectedModel)
        }
    }

    private var controlPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pop-out Controller")
                .font(.headline)
                .padding(.bottom, 4)

            Picker("Model", selection: $selectedModel) {
                ForEach(SampleModel.allCases) { model in
                    Text(model.displayName).tag(model)
                }
            }
            .onChange(of: selectedModel) { model in
                sceneController.load(model: model)
            }

            Toggle("Portal clipping", isOn: $sceneController.portalEnabled)

            Toggle("Face tracking", isOn: $useFaceTracking)

            VStack(alignment: .leading) {
                Text("Pop-out strength: \(String(format: "%.2f", sceneController.popOutStrength))")
                Slider(value: $sceneController.popOutStrength, in: 0...2)
            }

            VStack(alignment: .leading) {
                Text("Direction (degrees): \(Int(sceneController.popOutDirection))")
                Slider(value: $sceneController.popOutDirection, in: 0...360)
            }

            VStack(alignment: .leading) {
                Text("Camera offset scale: \(String(format: "%.2f", sceneController.cameraOffsetScale))")
                Slider(value: $sceneController.cameraOffsetScale, in: 0...2)
            }
        }
        .padding(12)
        .background(.thinMaterial)
        .cornerRadius(12)
        .shadow(radius: 8)
    }

    private func configureOverlayWindow(_ window: NSWindow) {
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        window.styleMask = [.borderless]
        window.isMovableByWindowBackground = true

        if let screen = window.screen ?? NSScreen.main {
            window.setFrame(screen.frame, display: true)
        }
    }
}
