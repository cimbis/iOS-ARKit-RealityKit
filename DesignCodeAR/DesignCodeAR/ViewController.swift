//
//  ViewController.swift
//  DesignCodeAR
//
//  Created by Janis Cimbulis on 02/09/2020.
//  Copyright © 2020 Janis Cimbulis. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    // ARSCNViewDelegate implemented in extension


    @IBOutlet var sceneView: ARSCNView!
    var focusSquare: FocusSquare?
    var screenCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // shows detected feature points in yellow
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints

        // add light where needed to better light the object
        sceneView.autoenablesDefaultLighting = true
        // and automatically update the lighting as well
        sceneView.automaticallyUpdatesLighting = true

        screenCenter = view.center

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/iPhoneX/iphone.scn")!

        // Set the scene to the view
        sceneView.scene = scene
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        //        configuration.planeDetection = [.horizontal, .vertical]
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    override func viewWillTransition(
            to size: CGSize,
            with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        self.screenCenter = CGPoint(
                x: size.width / 2,
                y: size.height / 2
        )
    }

    func updateFocusSquare() {
        guard let focusSquareLocal = self.focusSquare
        else {
            return
        }

        let hitTest = sceneView.hitTest(
                self.screenCenter,
                types: .existingPlaneUsingExtent
        )

        if let hitTestResult = hitTest.first {
            print("focus square hits a plane")
            let canAddNewModel = hitTestResult.anchor is ARPlaneAnchor
            focusSquareLocal.isClosed = canAddNewModel
        }
        else {
            print("focus square hits does not hit a plane")
            focusSquareLocal.isClosed = false
        }
    }


    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }
}
