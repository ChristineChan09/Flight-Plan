//
//  Info.swift
//  Flight Plan
//
//  Created by Cadence on 7/29/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//

import SpriteKit

class InfoScene: SKScene, SKPhysicsContactDelegate {
    
    /* UI Connections */
    var homeButton: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */
        
        /* Set UI connections */
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        
        /* Set physics contact delegate */
        physicsWorld.contactDelegate = self
        
        /* Main scene button selection handler */
        homeButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load main scene */
            let scene = MainScene(fileNamed: "MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
            
        }
    }
}

