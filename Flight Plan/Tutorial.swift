//
//  Tutorial.swift
//  Flight Plan
//
//  Created by Cadence on 7/30/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene, SKPhysicsContactDelegate {
    
    /* UI Connections */
    var nextArrow: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */
        
        /* Set UI connections */
        nextArrow = self.childNodeWithName("nextArrow") as! MSButtonNode
        
        /* Next arrow selection handler */
        nextArrow.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load game scene */
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)
        }
    }
}
