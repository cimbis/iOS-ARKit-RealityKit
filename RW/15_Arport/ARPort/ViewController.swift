import UIKit
import SceneKit
import ARKit

// MARK: - UIViewController

class ViewController: UIViewController {

    // MARK: - Properties
    var trackingStatus: String = ""
    var statusMessage: String = ""
    var appState: AppState = .DetectSurface
    var focusPoint: CGPoint!
    var focusNode: SCNNode!
    var arPortNode: SCNNode!

    // MARK: - IB Outlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!


    // MARK: - IB Actions
    @IBAction func resetButtonPressed(_ sender: Any) {
        self.resetARSession()
    }

    @IBAction func tapGestureHandler(_ sender: Any) {
        print("screen tapped")
        print(self.appState)
        guard self.appState == .TapToStart
        else {
            print("inside guard")
            return
        }
        print("after guard")
        self.arPortNode.isHidden = false
        self.focusNode.isHidden = true
        self.arPortNode.position = self.focusNode.position
        self.appState = .Started
    }

    // MARK - VC
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initScene()
        self.initCoachingOverlayView()
        self.initARSession()
        self.initFocusNode()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("*** ViewWillAppear()")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("*** ViewWillDisappear()")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("*** DidReceiveMemoryWarning()")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            if let touchLocation = touches.first?.location(in: self.sceneView) {
                if let hit = self.sceneView.hitTest(touchLocation, options: nil).first {
                    if hit.node.name == "Touch" {
                        let billboardNode = hit.node.childNode(withName: "Billboard", recursively: false)
                        billboardNode?.isHidden = false
                    }
                    if hit.node.name == "Billboard" {
                        hit.node.isHidden = true
                    }
                }
            }
        }
    }
}
