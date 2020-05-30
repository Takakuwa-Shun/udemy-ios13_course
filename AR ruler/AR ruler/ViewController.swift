//
//  ViewController.swift
//  AR ruler
//
//  Created by 高桑駿 on 2020/05/03.
//  Copyright © 2020 高桑駿. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes.removeAll()
        }
        
        if let firstTouch = touches.first {
            let location = firstTouch.location(in: sceneView)
            let results = sceneView.hitTest(location, types: .featurePoint)
            
            if let result = results.first {
                addDot(at: result)
            }
        }
    }
    
    func addDot(at hitResult: ARHitTestResult) -> Void {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        
        let node = SCNNode(geometry: dotGeometry)
        node.position = SCNVector3(
            x: hitResult.worldTransform.columns.3.x,
            y: hitResult.worldTransform.columns.3.y,
            z: hitResult.worldTransform.columns.3.z
        )
        
        sceneView.scene.rootNode.addChildNode(node)
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() -> Void {
        let start = dotNodes[0]
        let end = dotNodes[1]
        print(start.position)
        print(end.position)
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        updateText(test: String(distance), atPosition: end.position)
        print(distance)
    }
    
    func updateText(test: String, atPosition position: SCNVector3) -> Void {
        textNode.removeFromParentNode()
        
        let textGeometory = SCNText(string: test, extrusionDepth: 1.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        textGeometory.materials = [material]
        
        textNode = SCNNode(geometry: textGeometory)
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}

extension ViewController: ARSCNViewDelegate {
    
}
