//
//  ViewController+AppState.swift
//  ARPort
//
//  Created by Janis Cimbulis on 23/01/2021.
//

import Foundation

// MARK: - App Management
extension ViewController {
    enum AppState: Int16 {
        case DetectSurface
        case PointAtSurface
        case TapToStart
        case Started
    }

    func startApp() {
        DispatchQueue.main.async {
            self.appState = .DetectSurface
            self.arPortNode.isHidden = true
            self.focusNode.isHidden = true
        }
    }

    func resetApp() {
        DispatchQueue.main.async {
            self.resetARSession()
            self.appState = .DetectSurface
            self.arPortNode.isHidden = true
        }
    }
}
