//
//  ViewController.swift
//  TinyToyTank
//
//  Created by Janis Cimbulis on 12/12/2020.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    var tankAnchor: TinyToyTank._TinyToyTank?
    var isActionPlaying: Bool = false
    
    func checkIsActionPlaying() {
        if self.isActionPlaying {
            return
        }
        else {
            self.isActionPlaying = true
        }
    }
    
    @IBAction func tankRightPressed(_ sender: Any) {
        self.tankAnchor!.notifications.tankRight.post()
    }
    
    @IBAction func tankLeftPressed(_ sender: Any) {
        self.tankAnchor!.notifications.tankLeft.post()
    }
    
    @IBAction func tankForwardPressed(_ sender: Any) {
        self.tankAnchor!.notifications.tankForward.post()
    }
    
    @IBAction func turretRightPressed(_ sender: Any) {
        self.tankAnchor!.notifications.turretRight.post()
    }
    
    @IBAction func turretLeftPressed(_ sender: Any) {
        self.tankAnchor!.notifications.turretLeft.post()
    }
    
    @IBAction func cannonFirePressed(_ sender: Any) {
        self.tankAnchor!.notifications.cannonFire.post()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tankAnchor = try! TinyToyTank.load_TinyToyTank()
        self.tankAnchor!.cannon?.setParent(
            tankAnchor!.tank,
            preservingWorldTransform: true
        )
        self.tankAnchor!.actions.actionComplete.onAction = { _ in
            self.isActionPlaying = false
        }
        arView.scene.anchors.append(self.tankAnchor!)
    }
}
