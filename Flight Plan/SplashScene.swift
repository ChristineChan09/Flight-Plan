//
//  SplashScene.swift
//  Flight Plan
//
//  Created by Cadence on 8/11/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//

import SpriteKit


class SplashScene: SKScene {
    
    /* Time the intro screen */
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */

override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    
    }
    
override func update(currentTime: NSTimeInterval) {

    /* Update time */
    spawnTimer += fixedDelta
    if spawnTimer >= 3.2 {
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view as SKView!
        
        /* Load Game scene */
        let scene = MainScene(fileNamed: "MainScene") as MainScene!

        // Ensure correct aspect mode
        scene.scaleMode = .AspectFit

        /* Show debug */
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        
        // Start Game Scene
        skView.presentScene(scene)
            
        }
    }
}

 