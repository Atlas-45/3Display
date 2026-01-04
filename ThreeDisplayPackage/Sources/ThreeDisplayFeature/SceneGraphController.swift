import AppKit
import SceneKit
import SwiftUI

public enum SampleModel: String, CaseIterable, Identifiable {
    case proceduralCube
    case proceduralCapsule
    case bundledSample

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .proceduralCube:
            return "Procedural Cube"
        case .proceduralCapsule:
            return "Procedural Capsule"
        case .bundledSample:
            return "Bundled USDZ"
        }
    }
}

public final class SceneGraphController: ObservableObject {
    @Published public var portalEnabled: Bool = true {
        didSet { applyPortalClipping() }
    }

    @Published public var popOutStrength: Double = 0.75 {
        didSet { updatePopOutPosition() }
    }

    @Published public var popOutDirection: Double = 0 {
        didSet { updatePopOutPosition() }
    }

    @Published public var cameraOffsetScale: Double = 1.0

    @Published public var faceTrackingEnabled: Bool = false

    private let scene: SCNScene
    private let cameraNode: SCNNode
    private let lightNode: SCNNode
    private let ambientNode: SCNNode
    private var modelNode: SCNNode?

    private let clippingShader = """
    #pragma arguments
    float clipZ;
    #pragma body
    if (_worldPosition.z < clipZ) {
        discard_fragment();
    }
    """

    public init() {
        scene = SCNScene()
        cameraNode = SCNNode()
        lightNode = SCNNode()
        ambientNode = SCNNode()
        setupScene()
    }

    public func attach(to view: SCNView) {
        view.scene = scene
        view.backgroundColor = .clear
        view.autoenablesDefaultLighting = false
        view.allowsCameraControl = false
        view.isPlaying = true
        view.rendersContinuously = true
    }

    public func load(model: SampleModel) {
        modelNode?.removeFromParentNode()
        let node: SCNNode

        switch model {
        case .proceduralCube:
            node = makeCube()
        case .proceduralCapsule:
            node = makeCapsule()
        case .bundledSample:
            node = loadBundledUSDZ() ?? makeCube()
        }

        modelNode = node
        scene.rootNode.addChildNode(node)
        applyPortalClipping()
        updatePopOutPosition()
        addIdleAnimation(to: node)
    }

    public func updateCameraOffset(_ normalizedOffset: CGPoint) {
        let scaledX = Float(normalizedOffset.x) * Float(cameraOffsetScale)
        let scaledY = Float(normalizedOffset.y) * Float(cameraOffsetScale)
        cameraNode.position.x = 0 + scaledX
        cameraNode.position.y = 0 + scaledY
    }

    private func setupScene() {
        let camera = SCNCamera()
        camera.wantsHDR = true
        camera.wantsExposureAdaptation = true
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 8)
        scene.rootNode.addChildNode(cameraNode)

        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.color = NSColor(white: 1.0, alpha: 1.0)
        lightNode.position = SCNVector3(4, 4, 8)
        scene.rootNode.addChildNode(lightNode)

        ambientNode.light = SCNLight()
        ambientNode.light?.type = .ambient
        ambientNode.light?.color = NSColor(white: 0.35, alpha: 1.0)
        scene.rootNode.addChildNode(ambientNode)
    }

    private func makeCube() -> SCNNode {
        let box = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.systemTeal
        material.metalness.contents = 0.3
        material.roughness.contents = 0.25
        material.lightingModel = .physicallyBased
        box.materials = [material]
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(0, 0, 0)
        return node
    }

    private func makeCapsule() -> SCNNode {
        let capsule = SCNCapsule(capRadius: 0.8, height: 3.0)
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.systemPurple
        material.metalness.contents = 0.15
        material.roughness.contents = 0.2
        material.lightingModel = .physicallyBased
        capsule.materials = [material]
        let node = SCNNode(geometry: capsule)
        node.position = SCNVector3(0, 0, 0)
        return node
    }

    private func loadBundledUSDZ() -> SCNNode? {
        guard let url = Bundle.module.url(forResource: "Sample", withExtension: "usdz"),
              let source = SCNSceneSource(url: url, options: nil) else {
            return nil
        }
        let options: [SCNSceneSource.LoadingOption: Any] = [
            .checkConsistency: true,
            .convertToYUp: true
        ]

        guard let loadedScene = try? source.scene(options: options) else {
            return nil
        }

        let container = SCNNode()
        loadedScene.rootNode.childNodes.forEach { container.addChildNode($0) }
        let (min, max) = container.boundingBox
        let size = max - min
        let maxDimension = max(size.x, max(size.y, size.z))
        let scale = 2.5 / max(maxDimension, 0.001)
        container.scale = SCNVector3(scale, scale, scale)
        return container
    }

    private func addIdleAnimation(to node: SCNNode) {
        node.removeAllActions()
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0.4, y: 0.8, z: 0.3, duration: 6.0))
        let pulseUp = SCNAction.moveBy(x: 0, y: 0.25, z: 0, duration: 1.6)
        let pulseDown = SCNAction.moveBy(x: 0, y: -0.25, z: 0, duration: 1.6)
        pulseUp.timingMode = .easeInEaseOut
        pulseDown.timingMode = .easeInEaseOut
        let hover = SCNAction.repeatForever(SCNAction.sequence([pulseUp, pulseDown]))
        node.runAction(rotate, forKey: "rotate")
        node.runAction(hover, forKey: "hover")
    }

    private func updatePopOutPosition() {
        guard let node = modelNode else { return }
        let radians = popOutDirection * .pi / 180
        let x = cos(radians) * popOutStrength
        let z = sin(radians) * popOutStrength
        node.position = SCNVector3(x, 0, z)
    }

    private func applyPortalClipping() {
        guard let node = modelNode else { return }
        let materials = collectMaterials(from: node)

        if portalEnabled {
            materials.forEach { material in
                material.shaderModifiers = [.fragment: clippingShader]
                material.setValue(0.0, forKey: "clipZ")
            }
        } else {
            materials.forEach { material in
                material.shaderModifiers = nil
            }
        }
    }

    private func collectMaterials(from node: SCNNode) -> [SCNMaterial] {
        var materials: [SCNMaterial] = []
        if let geometryMaterials = node.geometry?.materials {
            materials.append(contentsOf: geometryMaterials)
        }

        for child in node.childNodes {
            materials.append(contentsOf: collectMaterials(from: child))
        }

        return materials
    }
}

private extension SCNVector3 {
    static func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
}
