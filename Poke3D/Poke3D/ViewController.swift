//
//  ViewController.swift
//  Poke3D
//
//  Created by 高桑駿 on 2020/05/03.
//  Copyright © 2020 高桑駿. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon cards", bundle: .main) {
            configuration.detectionImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            print("successfully added")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -Float.pi / 2 
            node.addChildNode(planeNode)
            
            var fileName: String
            switch imageAnchor.referenceImage.name {
            case "eevee-card":
                fileName = "eevee.scn"
            case "oddish-card":
                fileName = "oddish.scn"
            case "takakuwa":
                fileName = "oddish.scn"
            default:
                fileName = "eevee.scn"
            }

            if let pokeGeometory = SCNScene(named: "art.scnassets/\(fileName)"),
//            if let pokeGeometory = SCNScene(named: "art.scnassets/death-star-II.scn"),
            let pokeNode = pokeGeometory.rootNode.childNodes.first {
                pokeNode.eulerAngles.x = Float.pi / 2 
                planeNode.addChildNode(pokeNode)
            }
        }
        return node
    }
}
