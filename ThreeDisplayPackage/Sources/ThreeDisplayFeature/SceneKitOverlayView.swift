import AppKit
import SceneKit
import SwiftUI

struct SceneKitOverlayView: NSViewRepresentable {
    let controller: SceneGraphController

    func makeNSView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        controller.attach(to: view)
        return view
    }

    func updateNSView(_ view: SCNView, context: Context) {
        controller.attach(to: view)
    }
}
