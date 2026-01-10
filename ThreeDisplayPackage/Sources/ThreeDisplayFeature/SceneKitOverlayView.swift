import AppKit
import SceneKit
import SwiftUI

struct SceneKitOverlayView: NSViewRepresentable {
    let facePosition: CGPoint  // 顔の位置 (-1 to 1)
    let depthEffect: Double    // 奥行き効果の強さ
    let autoRotate: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> SCNView {
        let view = SCNView()
        view.scene = context.coordinator.scene
        view.backgroundColor = .clear
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = false
        view.isPlaying = true
        return view
    }

    func updateNSView(_ view: SCNView, context: Context) {
        context.coordinator.updateParallax(
            facePosition: facePosition,
            depthEffect: depthEffect,
            viewSize: view.bounds.size
        )
        context.coordinator.updateAnimation(autoRotate: autoRotate)
    }
}

final class Coordinator {
    let scene = SCNScene()
    private let cameraNode: SCNNode
    private let boxNode: SCNNode
    private var backgroundNodes: [SCNNode] = []
    private var isAutoRotating = true
    
    // カメラの基準位置
    private let baseCameraZ: Float = 5.0
    
    init() {
        // カメラ
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 60
        cameraNode.position = SCNVector3(0, 0, baseCameraZ)
        scene.rootNode.addChildNode(cameraNode)
        
        // メインライト
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 1000
        lightNode.position = SCNVector3(3, 3, 5)
        scene.rootNode.addChildNode(lightNode)
        
        // アンビエントライト
        let ambientNode = SCNNode()
        ambientNode.light = SCNLight()
        ambientNode.light?.type = .ambient
        ambientNode.light?.intensity = 400
        ambientNode.light?.color = NSColor(white: 0.6, alpha: 1.0)
        scene.rootNode.addChildNode(ambientNode)
        
        // ボックス（メインオブジェクト - 前景）
        let box = SCNBox(width: 1.5, height: 1.5, length: 1.5, chamferRadius: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = NSColor(red: 0.2, green: 0.7, blue: 0.8, alpha: 1.0)
        material.specular.contents = NSColor.white
        material.shininess = 0.8
        box.firstMaterial = material
        
        boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0, 0, 0)  // 中央に配置
        scene.rootNode.addChildNode(boxNode)
        
        // 背景オブジェクト（パララックス効果を強調）
        addBackgroundObjects()
        
        // 回転アニメーション開始
        startRotation()
    }
    
    private func addBackgroundObjects() {
        // 背景に小さな球体を配置（異なる深度で）
        let positions: [(Float, Float, Float, Float)] = [  // x, y, z, size
            (-2.5, 1.5, -2, 0.4),
            (2.5, -1.0, -3, 0.35),
            (-1.5, -1.5, -4, 0.3),
            (3.0, 0.5, -5, 0.25),
            (-3.0, 0.0, -3.5, 0.3),
        ]
        
        for (i, pos) in positions.enumerated() {
            let sphere = SCNSphere(radius: CGFloat(pos.3))
            let material = SCNMaterial()
            let hue = CGFloat(i) / CGFloat(positions.count)
            material.diffuse.contents = NSColor(hue: hue, saturation: 0.7, brightness: 0.9, alpha: 1.0)
            material.emission.contents = NSColor(hue: hue, saturation: 0.4, brightness: 0.4, alpha: 1.0)
            sphere.firstMaterial = material
            
            let node = SCNNode(geometry: sphere)
            node.position = SCNVector3(pos.0, pos.1, pos.2)
            node.name = "bg_\(i)"
            scene.rootNode.addChildNode(node)
            backgroundNodes.append(node)
        }
    }
    
    /// 顔の位置に応じてパララックス効果を適用
    func updateParallax(facePosition: CGPoint, depthEffect: Double, viewSize: CGSize) {
        guard viewSize.width > 0, viewSize.height > 0 else { return }
        
        let effect = Float(max(depthEffect, 0)) * 0.6
        let faceX = min(max(Float(facePosition.x), -1), 1)
        let faceY = min(max(Float(facePosition.y), -1), 1)
        
        let fovDegrees = cameraNode.camera?.fieldOfView ?? 60
        let fovRadians = Float(fovDegrees) * .pi / 180
        let halfHeight = tan(fovRadians * 0.5) * baseCameraZ
        let aspectRatio = Float(viewSize.width / viewSize.height)
        let halfWidth = halfHeight * aspectRatio
        
        let cameraOffsetX = faceX * halfWidth * effect
        let cameraOffsetY = faceY * halfHeight * effect
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.08
        
        cameraNode.position = SCNVector3(cameraOffsetX, cameraOffsetY, baseCameraZ)
        cameraNode.look(at: SCNVector3(0, 0, 0))
        
        SCNTransaction.commit()
    }
    
    func updateAnimation(autoRotate: Bool) {
        if autoRotate && !isAutoRotating {
            startRotation()
        } else if !autoRotate && isAutoRotating {
            boxNode.removeAction(forKey: "rotation")
        }
        isAutoRotating = autoRotate
    }
    
    private func startRotation() {
        let rotation = SCNAction.repeatForever(
            SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 8)
        )
        boxNode.runAction(rotation, forKey: "rotation")
    }
}
