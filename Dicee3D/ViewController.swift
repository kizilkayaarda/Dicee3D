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

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // creating the dice object
        let diceSCN = SCNScene(named: "art.scnassets/diceCollada.scn")
        
        if let diceNode = diceSCN?.rootNode.childNode(withName: "Dice", recursively: true) {
            
            diceNode.position = SCNVector3(0, 0, -0.3)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
        
        
        sceneView.autoenablesDefaultLighting = true
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
}
