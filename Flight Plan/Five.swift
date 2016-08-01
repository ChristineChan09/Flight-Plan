//
//  Five.swift
//  Flight Plan
//
//  Created by Cadence on 7/22/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//
import SpriteKit

enum FiveSceneState {
    case Active, Paused, GameOver
}

class FiveScene: SKScene, SKPhysicsContactDelegate {
    
    /* Camera helpers */
    var cameraTarget: SKNode!
    
    /* UI Connections */
    var lanternBird: SKSpriteNode!
    var backArrow: MSButtonNode!
    var homeButton: MSButtonNode!
    var rainbow: MSButtonNode!
    var lastPosition: CGFloat = 0
    var backgroundMusic: SKAudioNode!
    var Tutorial: SKLabelNode!
    var canDrawPath: Bool!
    
    /* Change game state */
    var fiveState: FiveSceneState = .Active
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */
        
        if let musicURL = NSBundle.mainBundle().URLForResource("Calm_music", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        }
        
        /* Setup bird character */
        lanternBird = self.childNodeWithName("lanternBird") as! SKSpriteNode
        
        /* Set UI connections */
        backArrow = self.childNodeWithName("backArrow") as! MSButtonNode
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        rainbow = self.childNodeWithName("rainbow") as! MSButtonNode
        
        /* Hide back arrow */
        backArrow.hidden = true
        
        /* Hide home button */
        homeButton.hidden = true
        
        /* Hide rainbow */
        rainbow.hidden = true
        
        /* Set physics contact delegate */
        physicsWorld.contactDelegate = self
        
        /* Last scene button selection handler */
        backArrow.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load last scene */
            let scene = FourScene(fileNamed: "Four") as FourScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
            /* Home button selection handler */
            homeButton.selectedHandler = {
            
            /* Grab reference to our Spritekit view */
            let skView = self.view as SKView!
            
            /* Reload current scene */
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
        
            /* Rainbow button selection handler */
            rainbow.selectedHandler = {
                
            /* Grab reference to our Spritekit view */
            let skView = self.view as SKView!
            
            /* Ensure correct aspect mode */
            self.scene!.scaleMode = .AspectFill
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            /* Start game scene */
            skView.presentScene(self.scene)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        /* Called when a touch begins */
        for child in self.children {
            if child.name == "circle"{
                child.removeFromParent()
            }
        }
        
        let location = touches.first!.locationInNode(self)
            if lanternBird.containsPoint(location) {
                // player is touching the bird, start drawing
                canDrawPath = true
            }
            else {
                // player is not touching the bird; don't start drawing
                canDrawPath = false
            }
        }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch moves */
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            let circle = SKSpriteNode(imageNamed: "Circle")
            circle.name = "circle"
            self.addChild(circle)
            circle.xScale = 0.06
            circle.yScale = 0.06
            circle.position = location
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Set camera to follow lines */
        cameraTarget = lanternBird
        lanternBird.removeAllActions()
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, lanternBird.position.x, lanternBird.position.y);
        
        if canDrawPath == true {
            for child in self.children {
                if child.name == "circle" {
                    CGPathAddLineToPoint(path, nil, child.position.x, child.position.y + 50);
                    
                    let move = SKAction.followPath(path, asOffset:false, orientToPath:false, duration:2.0)
                    lanternBird.runAction(move)
                }
            }
        }
    }
    
    func updateCamera() {
        if let camera = camera {
            camera.position = CGPoint(x: lanternBird!.position.x, y: lanternBird!.position.y)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // Camera follows lines
        if let cameraTarget = cameraTarget {camera?.position = cameraTarget.position}
        
        /* Clamp camera scrolling to our visible scene area only */
        camera?.position.x.clamp(0, 1344)
        
        if lanternBird.position.x < lastPosition{
            lanternBird.xScale = 1
        } else {
            lanternBird.xScale = -1
        }
        
        lastPosition = lanternBird.position.x
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        /* Ensure only called while game is running */
        if fiveState != .Active { return }
        
        if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4 {
            print(contact.bodyA)
            print(contact.bodyB)
            win()
            return
        }
        
        /* Change game state to game over */
        fiveState = .GameOver
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view! as SKView
        
        /* Load current scene */
        let scene = FiveScene(fileNamed:"Five")!
        
        /* Ensure correct aspect mode */
        scene.scaleMode = .AspectFill
        
        /* Restart current scene */
        skView.presentScene(scene)
        lanternBird.removeAllActions()
    }
    
    func win() { backArrow.hidden = false; homeButton.hidden = false; rainbow.hidden = false;
    lanternBird.removeAllActions()
    self.runAction(SKAction.playSoundFileNamed("Fanfare.wav", waitForCompletion: true))
        let gameScene: GameSceneState = .Paused
    }
}