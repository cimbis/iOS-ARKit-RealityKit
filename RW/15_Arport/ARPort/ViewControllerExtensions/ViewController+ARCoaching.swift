//
//  ViewController+ARCoaching.swift
//  ARPort
//
//  Created by Janis Cimbulis on 23/01/2021.
//

import ARKit

// MARK: - AR Coaching Overlay
extension ViewController: ARCoachingOverlayViewDelegate {

    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {

    }

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        self.startApp()
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        self.resetApp()
    }

    func initCoachingOverlayView() {
        let coachingOverlay = ARCoachingOverlayView()

        coachingOverlay.session = self.sceneView.session
        coachingOverlay.delegate = self
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.goal = .horizontalPlane

        self.sceneView.addSubview(coachingOverlay)

        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                                        NSLayoutConstraint(item: coachingOverlay,
                                                           attribute: .top,
                                                           relatedBy: .equal,
                                                           toItem: self.view,
                                                           attribute: .top,
                                                           multiplier: 1,
                                                           constant: 0),
                                        NSLayoutConstraint(item: coachingOverlay,
                                                           attribute: .bottom,
                                                           relatedBy: .equal,
                                                           toItem: self.view,
                                                           attribute: .bottom,
                                                           multiplier: 1,
                                                           constant: 0),
                                        NSLayoutConstraint(item: coachingOverlay,
                                                           attribute: .leading,
                                                           relatedBy: .equal,
                                                           toItem: self.view,
                                                           attribute: .leading,
                                                           multiplier: 1,
                                                           constant: 0),
                                        NSLayoutConstraint(item: coachingOverlay,
                                                           attribute: .trailing,
                                                           relatedBy: .equal,
                                                           toItem: self.view,
                                                           attribute: .trailing,
                                                           multiplier: 1,
                                                           constant: 0)
                                    ])
    }
}
