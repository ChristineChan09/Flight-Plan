//
//  GameScene.swift
//  Flight Plan
//
//  Created by Cadence on 7/13/16.
//  Copyright (c) 2016 Christine Chan. All rights reserved.
//

import SpriteKit


enum GameSceneState {
    case Active, GameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    /* Camera helpers */
    var cameraTarget: SKNode!
    var littleBird: SKSpriteNode!
    var circle: SKSpriteNode!
    
    /* UI Connections */
    var homeButton: MSButtonNode!
    var nextArrow: MSButtonNode!
    var rainbow: MSButtonNode!
    var lastPosition: CGFloat = 0
    var backgroundMusic: SKAudioNode!
    var canDrawPath: Bool!
    var defaultColor: SKColor = SKColor.whiteColor()
    var previousCircle: SKNode?
    
    /* Change game state */
    var gameState: GameSceneState = .Active
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */
        
        if musicState == true {
            let musicURL = NSBundle.mainBundle().URLForResource("Game-music", withExtension: "mp3") 
                backgroundMusic = SKAudioNode(URL: musicURL!)
                
                addChild(backgroundMusic)
        }
        
        littleBird = childNodeWithName("littlebird") as! SKSpriteNode
        defaultColor = littleBird.color
        
        /* Set UI connections */
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        nextArrow = self.childNodeWithName("nextArrow") as! MSButtonNode
        rainbow = self.childNodeWithName("rainbow") as! MSButtonNode

        /* Hide home button */
        homeButton.hidden = true
        
        /* Hide next button */
        nextArrow.hidden = true
        
        /* Hide rainbow */
        rainbow.hidden = true
        
        /* Set physics contact delegate */
        physicsWorld.contactDelegate = self
        
        /* Home scene button selection handler */
        homeButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load previous scene */
            let scene = MainScene(fileNamed: "MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill

            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)
            
        }
        
        /* Next scene button selection handler */
        self.nextArrow.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load next scene */
            let scene = TwoScene(fileNamed: "Two") as TwoScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        /* Rainbow button selection handler */
        self.rainbow.selectedHandler = {}
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Set var canDraw to true so users can start drawing, else make false */
          if gameState != .Active { return }
        
//          Called when a touch begins
            for child in self.children {
            if child.name == "circle" {
                child.removeFromParent()
            }
        }
        
        let location = touches.first!.locationInNode(self)
        if littleBird.containsPoint(location) {
            // the user is touching the bird
            canDrawPath = true
            littleBird.color = .grayColor()
        }
        else {
            // the user is not touching the bird; don't start drawing
            canDrawPath = false
        }
    }
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameState != .Active { return }
        
        /* Called when a touch moves */
        for touch in touches {
            
            let location = touch.locationInNode(self)
            if location.x < 0 || location.y < 0 || location.x > 1344 || location.y > 750{return}
            
            
            if previousCircle == nil {
                // this is the first circle
                let circle = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 16, height: 16))
                circle.name = "circle"
                self.addChild(circle)
                circle.position = location
                previousCircle = circle
            }
            else {
                // connect the previous circle to the touch location
                
                let previousLocation = previousCircle!.convertPoint(CGPoint(x: -8, y: 0), toNode: self)
                let diff = location - previousLocation
                
                if diff.length() > 16 {
                    let center = (location + previousLocation) * 0.5
                    
                    let circle = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 16, height: 16))
                    circle.xScale = diff.length() / 16
                    circle.zRotation = -CGFloat(atan2f(Float(diff.x), Float(diff.y))) - CGFloat(M_PI_2)
                    circle.name = "circle"
                    self.addChild(circle)
                    circle.position = center
                    previousCircle = circle
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Set camera to follow bird(s) */
        if gameState != .Active { return }
        
        littleBird.color = defaultColor 
        cameraTarget = littleBird
        littleBird.removeAllActions()
        previousCircle = nil
    
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, littleBird.position.x, littleBird.position.y);

        if canDrawPath == true {
            for child in self.children {
                if child.name == "circle" {
                    CGPathAddLineToPoint(path, nil, child.position.x, child.position.y + 50);
                }
            }
            let move = SKAction.followPath(path, asOffset:false, orientToPath:false, duration:2.0)
            littleBird.runAction(move)
        }
    }
    
     override func update(currentTime: CFTimeInterval) {
            /* Called before each frame is rendered */
            if gameState != .Active { return }
        
            // Camera follows bird
            if let cameraTarget = cameraTarget {camera?.position = cameraTarget.position}

            /* Clamp camera scrolling to our visible scene area only */
            camera?.position.x.clamp(180,580)
        
           if littleBird.position.x < lastPosition{
            littleBird.xScale = -1
          } else {
            littleBird.xScale = 1
          }
        
            lastPosition = littleBird.position.x
        }
    
    func didBeginContact(contact: SKPhysicsContact) {
    
        /* Ensure only called while game running */
        if gameState != .Active { return }
        
        if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4{
            print(contact.bodyA)
            print(contact.bodyB)
            win()
            return
        }
        
        /* Change game state to game over */
        gameState = .GameOver
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view! as SKView

        /* Load Game scene */
        let scene = GameScene(fileNamed:"GameScene")!

        /* Ensure correct aspect mode */
        scene.scaleMode = .AspectFill

        /* Restart game scene */
        skView.presentScene(scene)
        littleBird.removeAllActions()
    }
    
    func win() {
        littleBird.removeAllActions()
        for child in self.children {
            if child.name == "circle"{
                child.removeFromParent()
            }
        }

        gameState = .GameOver
        
        nextArrow.hidden = false; homeButton.hidden = false; rainbow.hidden = false;
        littleBird.removeAllActions()
        
        if musicState == true {
            self.runAction(SKAction.playSoundFileNamed("Winning-sound.wav", waitForCompletion: false))
        }
    }
}