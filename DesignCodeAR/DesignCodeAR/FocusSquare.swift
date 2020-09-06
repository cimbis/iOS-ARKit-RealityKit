//
// Created by Janis Cimbulis on 05/09/2020.
// Copyright (c) 2020 Janis Cimbulis. All rights reserved.
//

import Foundation
import SceneKit

class FocusSquare: SCNNode {

    var isClosed: Bool = true {
        didSet {
            geometry?.firstMaterial?.diffuse.contents = self.isClosed ? UIImage(named: "fs/close") : UIImage(named: "fs/open")
        }
    }
    
    override init() {
        super.init()

        let plane = SCNPlane(width: 0.1, height: 0.1)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "fs/close")
        plane.firstMaterial?.isDoubleSided = true

        geometry = plane
        eulerAngles.x = GLKMathDegreesToRadians(-90)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
