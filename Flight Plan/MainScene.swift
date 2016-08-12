//
//  MainScene.swift
//  Flight Plan
//
//  Created by Cadence on 7/23/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//

import SpriteKit

var musicState: Bool = true

class MainScene: SKScene {
    
    /* UI Connections */
    var infoButton: MSButtonNode!
    var playButton: MSButtonNode!
    var settingsButton: MSButtonNode!
    var chooseLevel: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        infoButton = self.childNodeWithName("infoButton") as! MSButtonNode
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        settingsButton = self.childNodeWithName("settingsButton") as! MSButtonNode
        chooseLevel = self.childNodeWithName("chooseLevel") as! MSButtonNode
        
        /* Setup information button selection handler */
        infoButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = InfoScene(fileNamed: "Info") as InfoScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            let background = SKSpriteNode(imageNamed: "Flight-Plan")
            background.size = self.size
            background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            background.zPosition = 0
            self.addChild(background)
            
            /* Start scene */
            skView.presentScene(scene)
            
        }

        /* Setup play button selection handler */
        playButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Tutorial scene */
            let scene = TutorialScene(fileNamed: "Tutorial") as TutorialScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
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
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup level selection handler */
        chooseLevel.selectedHandler = {
        
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Level scene */
            let scene = LevelScene(fileNamed: "Level") as LevelScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
    }
}
