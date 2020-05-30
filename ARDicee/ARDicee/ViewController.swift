//
//  ViewController.swift
//  ARDicee
//
//  Created by 高桑駿 on 2020/05/02.
//  Copyright © 2020 高桑駿. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        self.sceneView.debugOptions = [.showFeaturePoints]
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
//        let sphere = SCNSphere(radius: 0.2)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/sun.jpg")
//        sphere.materials = [material]
//
//        let node = SCNNode()
//        node.position = SCNVector3(0, 0.1, -1.0)
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)
//        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func refleshTapped(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    @IBAction func removeTapped(_ sender: UIBarButtonItem) {
        if diceArray.isEmpty {
            return
        }
        for dice in diceArray {
            dice.removeFromParentNode()
        }
        print(diceArray)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print(motion)
        rollAll()
    }
    
    func roll(dice: SCNNode) -> Void {
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(randomX * 5),
            y: 0,
            z: CGFloat(randomZ * 5),
            duration: 0.5)
        )
    }
    
    func rollAll() -> Void {
        if diceArray.isEmpty {
            return
        }
        for dice in diceArray {
            roll(dice: dice)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitResult = results.first,
               let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn"),
               let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                diceNode.position = SCNVector3(
                    hitResult.worldTransform.columns.3.x,
                    hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                    hitResult.worldTransform.columns.3.z
                )
                sceneView.scene.rootNode.addChildNode(diceNode)
                diceArray.append(diceNode)
                roll(dice: diceNode)
            }
        }
    }
    
}

//MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
            
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        
        let planeNode = SCNNode()
        planeNode.geometry = plane
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        node.addChildNode(planeNode)
    }
}
