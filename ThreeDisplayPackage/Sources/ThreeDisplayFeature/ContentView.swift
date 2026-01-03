import AppKit
import SwiftUI

public struct ContentView: View {
    @State private var didConfigureWindow = false

    public init() {}

    public var body: some View {
        ZStack {
            SceneKitOverlayView()
                .ignoresSafeArea()

            WindowAccessor { window in
                guard let window, !didConfigureWindow else { return }
                configureOverlayWindow(window)
                didConfigureWindow = true
            }
        }
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
