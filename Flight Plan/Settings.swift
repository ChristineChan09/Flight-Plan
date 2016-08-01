//
//  Settings.swift
//  Flight Plan
//
//  Created by Cadence on 7/29/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene, SKPhysicsContactDelegate {

    /* UI Connections */
    var homeButton: MSButtonNode!
    var backgroundMusic: SKAudioNode!
    var volumeOn: MSButtonNode!
    var volumeOff: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */
        
        /* Set UI connections */
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        volumeOn = self.childNodeWithName("volumeOn") as! MSButtonNode
        volumeOff = self.childNodeWithName("volumeOff") as! MSButtonNode
        
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
            
            /* Start scene */
            skView.presentScene(scene)
            
        }
        
//        /* Volume off button selection handler */
//        volumeOff.selectedHandler = {
//            
//            /* Grab reference to our SpriteKit view */
//            let skView = self.view as SKView!
//            
//            if let musicURL = NSBundle.mainBundle().URLForResource("Calm_music", withExtension: "mp3") {
//            self.backgroundMusic = SKAudioNode(URL: musicURL)
//        }
//            
//            /* Ensure correct aspect mode */
//            scene.scaleMode = .AspectFill
//            
//            /* Start game scene */
//            skView.presentScene(scene)
//            
//        }
//        /* Volume off button selection handler */
//        volumeOff.selectedHandler = {
//
//            /* Grab reference to our SpriteKit view */
//            let skView = self.view as SKView!
//
//            if let musicURL = NSBundle.mainBundle().URLForResource("Calm_music", withExtension: "mp3") {
//            self.backgroundMusic = SKAudioNode(URL: musicURL)
//        }
//
//            /* Ensure correct aspect mode */
//            scene.scaleMode = .AspectFill
//
//            /* Start game scene */
//            skView.presentScene(scene)
//            
//        }
    }
}

