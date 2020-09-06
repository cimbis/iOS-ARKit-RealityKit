import UIKit
import ARKit
import SceneKit

extension SCNVector3 {
    func distance(to destination: SCNVector3) -> CGFloat {
        let dx = destination.x - x
        let dy = destination.y - y
        let dz = destination.z - z

        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }

    static func positionFrom(matrix: matrix_float4x4) -> SCNVector3 {
        let column = matrix.columns.3
        return SCNVector3(column.x, column.y, column.z)
    }
}

class ViewController: UIViewController, ARSCNViewDelegate {

    var nodes: [SphereNode] = []

    lazy var sceneView: ARSCNView = {
        let view = ARSCNView(frame: .zero)
        view.delegate = self
        return view
    }()

    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneView)
        view.addSubview(infoLabel)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.numberOfTapsRequired = 1

        sceneView.addGestureRecognizer(tapRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = view.bounds
        infoLabel.frame = CGRect(x: 0, y: 16, width: view.bounds.width, height: 64)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(
                configuration,
                options: [.resetTracking, .removeExistingAnchors])
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        var status = "Loading ..."

        switch camera.trackingState {
        case .notAvailable:
            status = "Not Available :("
        case .limited(_):
            status = "Analyzing ..."
        case .normal:
            status = "Ready!"
        }

        infoLabel.text = status
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .featurePoint)

        if let result = hitTestResults.first {
            let position = SCNVector3.positionFrom(matrix: result.worldTransform)
            let sphere = SphereNode(position: position)
            let lastNode = nodes.last

            nodes.append(sphere)
            sceneView.scene.rootNode.addChildNode(sphere)

            if lastNode != nil {
                let distance = lastNode!.position.distance(to: sphere.position)
                infoLabel.text = String(format: "Distance: %.2f meters", distance)
            }
        }
    }
}

