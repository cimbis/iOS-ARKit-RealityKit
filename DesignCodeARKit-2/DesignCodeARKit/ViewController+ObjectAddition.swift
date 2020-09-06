import UIKit
import SceneKit
import ARKit

extension ViewController {

    fileprivate func getModel(named modelName: String) -> SCNNode? {
        let scene = SCNScene(named: "art.scnassets/\( modelName )/\( modelName ).scn")

        guard let model = scene?.rootNode.childNode(withName: "SketchUp", recursively: false)
        else {
            return nil
        }

        model.name = modelName

        var scale: CGFloat
        switch modelName {
            case "iPhoneX":         scale = 0.025
            case "iPhone6s":        scale = 0.025
            case "iPhone7":         scale = 0.0001
            case "iPhone8":         scale = 0.000008
            case "iPhone8Plus":     scale = 0.000008
            case "iPad4":           scale = 0.0006
            case "MacBookPro13":    scale = 0.0029
            case "iMacPro":         scale = 0.0245
            case "AppleWatch":      scale = 0.0000038
            default:                scale = 1
        }

        model.scale = SCNVector3(scale, scale, scale)
        return model
    }


    @IBAction func addObjectButtonTapped(_ sender: Any) {
        print("button tapped")

        guard focusSquare != nil
        else {
            return
        }

        let modelName = "iPhoneX"
        guard let model = getModel(named: modelName)
        else {
            print("unable to load \( modelName ) model")
            return
        }

        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        guard let worldTransformCol3 = hitTest.first?.worldTransform.columns.3
        else {
            return
        }

        model.position = SCNVector3(
                x: worldTransformCol3.x,
                y: worldTransformCol3.y,
                z: worldTransformCol3.z
        )

        sceneView.scene.rootNode.addChildNode(model)
        print("\( modelName ) added to scene")

        modelsInScene.append(model)
        print("num of models in scene: \( modelsInScene.count )")
    }
}

