//
//  ViewController.swift
//  Dicee3D
//
//  Created by Cemal Arda KIZILKAYA on 1.12.2018.
//  Copyright © 2018 Cemal Arda KIZILKAYA. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // to store the dice that are added to the scene
    var diceArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
       
        sceneView.autoenablesDefaultLighting = true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let testResults = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = testResults.first {
                
                let diceSCN = SCNScene(named: "art.scnassets/diceCollada.scn")
 
                if let diceNode = diceSCN?.rootNode.childNode(withName: "Dice", recursively: true) {
 
                    diceNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        z: hitResult.worldTransform.columns.3.z
                    )
                    
                    diceArray.append(diceNode)
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    rollDice(dice: diceNode)
                }
            }
                
        }
    }
    
    // MARK: - Functions for dice rolls
    func rollAllOnTheSurface() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                rollDice(dice: dice)
            }
        }
    }
    
    func rollDice(dice: SCNNode) {
        
        // generating random angles for rolling animation
        let randX = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        let randZ = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randX * 5), y: 0, z: CGFloat(randZ * 5), duration: 0.5))
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAllOnTheSurface()
    }
    
    @IBAction func rollButtonPressed(_ sender: Any) {
        rollAllOnTheSurface()
    }
    
    // MARK: - Function for removing all dice on the scene
    @IBAction func removeAll(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [material]
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        }
    }
}
