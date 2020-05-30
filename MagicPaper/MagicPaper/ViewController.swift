//
//  ViewController.swift
//  MagicPaper
//
//  Created by 高桑駿 on 2020/05/06.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "PaperImages", bundle: .main) {
            configuration.trackingImages = imagesToTrack
            configuration.maximumNumberOfTrackedImages = 1
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
            let videoNode = SKVideoNode(fileNamed: "sea.mp4")
            videoNode.play()
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            videoNode.yScale = -1
            videoScene.addChild(videoNode)
            
            let planeGeometory = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            planeGeometory.firstMaterial?.diffuse.contents = videoScene
            let planeNode = SCNNode(geometry: planeGeometory)
            planeNode.eulerAngles.x = -Float.pi/2
            node.addChildNode(planeNode)
        }
        return node
    }
}
