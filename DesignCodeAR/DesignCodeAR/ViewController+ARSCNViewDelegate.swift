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
        plane.firstMaterial?.isDoubleSided = true

        let planeNode = SCNNode(geometry: plane)

        planeNode.position = SCNVector3(
                planeAnchor.center.x,
                planeAnchor.center.y,
                planeAnchor.center.z
        )

        // need to rotate horizontal plane nodes by 90 degrees
        // planeNode.eulerAngles.x = -.pi / 2
        planeNode.eulerAngles.x = GLKMathDegreesToRadians(90)
        return planeNode
    }

    /**
        ## "did Add node" delegate

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

        print("plane detected")

        let planeAnchor = anchor as! ARPlaneAnchor
        let planeNode = createPlane(planeAnchor: planeAnchor)

        node.addChildNode(planeNode)
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

        print("surface updated")

        // remove old nodes
        node.enumerateChildNodes { childNode, pointer in
            childNode.removeFromParentNode()
        }

        // create new nodes with new dimensions
        let planeAnchor = anchor as! ARPlaneAnchor
        let planeNode = createPlane(planeAnchor: planeAnchor)

        node.addChildNode(planeNode)
    }

    /**
        ## "did Remove node" delegate

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

        node.enumerateChildNodes { childNode, _ in
            childNode.removeFromParentNode()
        }
    }
}
