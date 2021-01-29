//
// Created by Janis Cimbulis on 29/01/2021.
//

import SceneKit

extension ViewController {

    func setFocusPoint() {
        focusPoint = CGPoint(
                x: view.center.x,
                y: view.center.y + view.center.y * 0.1
        )
    }

    func initFocusNode() {
        let focusScene = SCNScene(named: "art.scnassets/Scenes/FocusScene.scn")!

        self.focusNode = focusScene.rootNode.childNode(withName: "Focus", recursively: false)
        self.focusNode.isHidden = true
        self.sceneView.scene.rootNode.addChildNode(self.focusNode)

        self.setFocusPoint()

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(ViewController.orientationChanged),
                name: UIDevice.orientationDidChangeNotification,
                object: nil
        )
    }

    func updateFocusNode() {
        guard self.appState != .Started
        else {
            self.focusNode.isHidden = true
            return
        }

        if let query = self.sceneView.raycastQuery(
                from: self.focusPoint,
                allowing: .estimatedPlane,
                alignment: .horizontal
        ) {
            let results = self.sceneView.session.raycast(query)

            if results.count == 1 {
                if let match = results.first {
                    let t = match.worldTransform

                    self.focusNode.position = SCNVector3(
                            x: t.columns.3.x,
                            y: t.columns.3.y,
                            z: t.columns.3.z
                    )

                    self.appState = .TapToStart
                    self.focusNode.isHidden = false
                }
            }
            else {
                self.appState = .PointAtSurface
                self.focusNode.isHidden = true
            }
        }
    }

    @objc
    func orientationChanged() {
        self.setFocusPoint()
    }
}
