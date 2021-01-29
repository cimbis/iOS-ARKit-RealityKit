//
//  ViewController+SceneManagement.swift
//  ARPort
//
//  Created by Janis Cimbulis on 23/01/2021.
//

import ARKit

// MARK: - Scene Management
extension ViewController: ARSCNViewDelegate {
    func initScene() {
        let scene = SCNScene()
        self.sceneView.scene = scene
        self.sceneView.delegate = self

        let arPortScene = SCNScene(named: "art.scnassets/Scenes/ARPortScene.scn")
        self.arPortNode = arPortScene?.rootNode.childNode(withName: "ARPort", recursively: false)
        self.arPortNode.isHidden = true
        self.sceneView.scene.rootNode.addChildNode(self.arPortNode)

        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [
            ARSCNDebugOptions.showFeaturePoints,
            ARSCNDebugOptions.showCreases,
            ARSCNDebugOptions.showWorldOrigin,
            ARSCNDebugOptions.showBoundingBoxes,
            ARSCNDebugOptions.showWireframe
        ]
    }

    func updateStatus() {
        switch self.appState {
            case .DetectSurface:
                self.statusMessage = "Scan available flat surfaces..."
                break

            case .PointAtSurface:
                self.statusMessage = "Point at designated surface first!"
                break

            case .TapToStart:
                self.statusMessage = "Tap to start."
                break

            case .Started:
                self.statusMessage = "Tap objects for more info."
                break
        }

        self.statusLabel.text = self.trackingStatus != ""
            ? "\(self.trackingStatus)"
            : "\(self.statusMessage)"
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateStatus()
            self.updateFocusNode()
        }
    }
}
