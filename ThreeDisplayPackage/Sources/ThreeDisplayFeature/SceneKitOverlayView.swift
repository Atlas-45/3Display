import AppKit
import SceneKit
import SwiftUI

struct SceneKitOverlayView: NSViewRepresentable {
    func makeNSView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        view.scene = makeScene()
        view.backgroundColor = .clear
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = false
        view.isPlaying = true
        view.rendersContinuously = true
        return view
    }

    func updateNSView(_ view: SCNView, context: Context) {
    }

    private func makeScene() -> SCNScene {
        let scene = SCNScene()

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 8)
        scene.rootNode.addChildNode(cameraNode)

        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(4, 4, 8)
        scene.rootNode.addChildNode(lightNode)

        let ambientNode = SCNNode()
        ambientNode.light = SCNLight()
        ambientNode.light?.type = .ambient
        ambientNode.light?.color = NSColor(white: 0.3, alpha: 1.0)
        scene.rootNode.addChildNode(ambientNode)

        let box = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.1)
        box.firstMaterial?.diffuse.contents = NSColor.systemTeal
        box.firstMaterial?.metalness.contents = 0.3
        box.firstMaterial?.roughness.contents = 0.2

        let boxNode = SCNNode(geometry: box)
        scene.rootNode.addChildNode(boxNode)

        let rotate = SCNAction.repeatForever(
            SCNAction.rotateBy(x: 0.6, y: 1.0, z: 0.2, duration: 6.0)
        )
        boxNode.runAction(rotate)

        return scene
    }
}
