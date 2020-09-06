//
// Created by Janis Cimbulis on 05/09/2020.
// Copyright (c) 2020 Janis Cimbulis. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ViewController: ARSCNViewDelegate {

    /**
        ## "create plane" private method

        - Parameter planeAnchor: anchor of detected surface
        - Returns: SCNNode plane to draw on detected surface
    */
    func createPlane(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(
                width: CGFloat(planeAnchor.extent.x),
                height: CGFloat(planeAnchor.extent.z)
        )
        plane.firstMaterial?.diffuse.contents = UIImage(named: "grid")
        plane.firstMaterial?.isDoubleSided = true

        let planeNode = SCNNode(geometry: plane)

        planeNode.position = SCNVector3(
                planeAnchor.center.x,
                planeAnchor.center.y,
                planeAnchor.center.z
        )

        // need to rotate horizontal plane nodes by 90 degrees
        // planeNode.eulerAngles.x = -.pi / 2
        planeNode.eulerAngles.x = GLKMathDegreesToRadians(-90)
        
        return planeNode
    }

    /**
        ## "add plane" private method

        - Parameter for anchor: anchor of detected surface
        - Parameter on node: parent node to which the plane will be attached
    */
//    private func addPlane(for anchor: ARAnchor, on node: SCNNode) {
//        guard anchor is ARPlaneAnchor
//        else {
//            return
//        }
//
//        print("plane detected")
//
//        let planeAnchor = anchor as! ARPlaneAnchor
//        let planeNode = createPlane(planeAnchor: planeAnchor)
//
//        node.addChildNode(planeNode)
//    }

    /**
        ## "add focus square if necessary" helper method
    */
    private func addFocusSquareIfNecessary() {
        guard self.focusSquare == nil
        else {
            return
        }

        print("adding focus square")

        let focusSquareLocal = FocusSquare()
        self.sceneView.scene.rootNode.addChildNode(focusSquareLocal)
        self.focusSquare = focusSquareLocal
    }

    /**
        ## "did add node" delegate

        - if a surface is detected, add it to scene node child list
    */
    public func renderer(
            _ renderer: SCNSceneRenderer,
            didAdd node: SCNNode,
            for anchor: ARAnchor
    ) {
        guard anchor is ARPlaneAnchor
        else {
            return
        }
        print("Horizontal surface detected")
//        addPlane(for: anchor, on: node)
        addFocusSquareIfNecessary()
    }

    /**
        ## "did Update node" delegate

        - process updates of anchor points of surface
   */
    public func renderer(
            _ renderer: SCNSceneRenderer,
            didUpdate node: SCNNode,
            for anchor: ARAnchor
    ) {
        guard anchor is ARPlaneAnchor
        else {
            return
        }
//
//        print("surface updated")
//
//         remove old nodes
//        node.enumerateChildNodes { childNode, pointer in
//            childNode.removeFromParentNode()
//        }
//
//        // create new nodes with new dimensions
//        let planeAnchor = anchor as! ARPlaneAnchor
//        let planeNode = createPlane(planeAnchor: planeAnchor)
//
//        node.addChildNode(planeNode)
    }

    /**
        ## "did remove node" delegate

        - process removal of anchor points of surface
    */
    public func renderer(
            _ renderer: SCNSceneRenderer,
            didRemove node: SCNNode,
            for anchor: ARAnchor
    ) {
        guard anchor is ARPlaneAnchor
        else {
            return
        }
        print("surface removed")
//
//        node.enumerateChildNodes { childNode, _ in
//            childNode.removeFromParentNode()
//        }
    }

    /**
        ## "update at time" delegate
    */
    public func renderer(
            _ renderer: SCNSceneRenderer,
            updateAtTime time: TimeInterval
    ) {
        guard let focusSquareLocal = self.focusSquare
        else {
            return
        }

        let hitTest = sceneView.hitTest(
                self.screenCenter,
                types: .existingPlane
        )
        let hitTestResult = hitTest.first

        guard let worldTransform = hitTestResult?.worldTransform
        else {
            return
        }

        // World transform is a 4x4 matrix and the position is kept in the fourth column.
        let worldTransformCol3 = worldTransform.columns.3
        focusSquareLocal.position = SCNVector3(
                worldTransformCol3.x,
                worldTransformCol3.y,
                worldTransformCol3.z
        )

        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
    }
}
