//
//  Level.swift
//  Flight Plan
//
//  Created by Cadence on 8/4/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    
    /* UI Connections */
    var homeButton: MSButtonNode!
    var One: MSButtonNode!
    var Two: MSButtonNode!
    var Three: MSButtonNode!
    var Four: MSButtonNode!
    var Five: MSButtonNode!
    var Six: MSButtonNode!
    var Seven: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        One = self.childNodeWithName("One") as! MSButtonNode
        Two = self.childNodeWithName("Two") as! MSButtonNode
        Three = self.childNodeWithName("Three") as! MSButtonNode
        Four = self.childNodeWithName("Four") as! MSButtonNode
        Five = self.childNodeWithName("Five") as! MSButtonNode
        Six = self.childNodeWithName("Six") as! MSButtonNode
        Seven = self.childNodeWithName("Seven") as! MSButtonNode

        /* Setup main scene selection handler */
        homeButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load main scene */
            let scene = MainScene(fileNamed: "MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup level one button handler */
        One.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load first level game scene */
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup level two button handler */
        Two.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load level two game scene */
            let scene = TwoScene(fileNamed: "Two") as TwoScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup level three button handler */
        Three.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load level three game scene */
            let scene = ThreeScene(fileNamed: "Three") as ThreeScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup level four button handler */
        Four.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load level four game scene */
            let scene = FourScene(fileNamed: "Four") as FourScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup level five button handler */
        Five.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load level five game scene */
            let scene = FiveScene(fileNamed: "Five") as FiveScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup level six button handler */
        Six.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load level six game scene */
            let scene = SixScene(fileNamed: "Six") as SixScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start scene */
            skView.presentScene(scene)
        }
        
        /* Setup level seven button handler */
        Seven.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load level seven game scene */
            let scene = SevenScene(fileNamed: "Seven") as SevenScene!
            
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
