//
//  ViewController+ARSession.swift
//  ARPort
//
//  Created by Janis Cimbulis on 23/01/2021.
//

import ARKit

// MARK: - AR Session Management (ARSCNViewDelegate)
extension ViewController {

    func initARSession() {
        guard ARWorldTrackingConfiguration.isSupported
        else {
            print("*** ARConfig: AR World Tracking Not Supported")
            return
        }

        let config = ARWorldTrackingConfiguration()
        // sets the coordinate system’s y-axis parallel to gravity,
        // with the origin to the initial position of the device.
        config.worldAlignment = .gravity
        config.providesAudioData = false
        config.planeDetection = .horizontal
        config.isLightEstimationEnabled = true
        config.environmentTexturing = .automatic

        self.sceneView.session.run(config)
    }

    func resetARSession() {
        let config = self.sceneView.session.configuration as! ARWorldTrackingConfiguration
        config.planeDetection = .horizontal
        self.sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
            case .notAvailable:
                self.trackingStatus = "Tracking: Not Available!"

            case .normal:
                self.trackingStatus = ""

            case .limited(let reason):
                switch reason {
                    case .excessiveMotion:
                        self.trackingStatus = "Tracking: Limited due to excessive motion!"

                    case .insufficientFeatures:
                        self.trackingStatus = "Tracking: Limited due to insufficient features!"

                    case .relocalizing:
                        self.trackingStatus = "Tracking: Relocalizing..."

                    case .initializing:
                        self.trackingStatus = "Tracking: Initializing..."

                    @unknown default:
                        self.trackingStatus = "Tracking: Unknown..."
                }
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        self.trackingStatus = "AR Session Failure \( error )"
    }

    func sessionWasInterrupted(_ session: ARSession) {
        self.trackingStatus = "AR Session Was Interrupted!"
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        self.trackingStatus = "AR Session Interruption Ended"
    }
}
