//
//  MainScene.swift
//  Flight Plan
//
//  Created by Cadence on 7/23/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//

import SpriteKit

class MainScene: SKScene {
    
    /* UI Connections */
    var infoButton: MSButtonNode!
    var playButton: MSButtonNode!
    var settingsButton: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        infoButton = self.childNodeWithName("infoButton") as! MSButtonNode
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        settingsButton = self.childNodeWithName("settingsButton") as! MSButtonNode
        
        /* Setup restart button selection handler */
        playButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Tutorial scene */
            let scene = TutorialScene(fileNamed: "Tutorial") as TutorialScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup settings button selection handler */
        settingsButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = SettingsScene(fileNamed: "Settings") as SettingsScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup information button selection handler */
        infoButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = InfoScene(fileNamed: "Info") as InfoScene!
            
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
