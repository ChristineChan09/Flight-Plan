//
//  Three.swift
//  Flight Plan
//
//  Created by Cadence on 7/22/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//
import SpriteKit

enum ThreeSceneState {
    case Active, GameOver
}

class ThreeScene: SKScene, SKPhysicsContactDelegate {
    
    /* Camera helpers */
    var littleBird: SKSpriteNode!
    var square: SKSpriteNode!
    var cameraTarget: SKNode!
    
    /* UI Connections */
    var backArrow: MSButtonNode!
    var nextArrow: MSButtonNode!
    var rainbow: MSButtonNode!
    var enemyBird: SKSpriteNode!
    var lastPosition: CGFloat = 0
    var backgroundMusic: SKAudioNode!
    var canDrawPath: Bool!
    var defaultColor: SKColor = SKColor.whiteColor()
    var previousSquare: SKNode?
    
    /* Change game state */
    var threeState: ThreeSceneState = .Active
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */
        
        if musicState == true {
            let musicURL = NSBundle.mainBundle().URLForResource("Game-music", withExtension: "mp3")
            backgroundMusic = SKAudioNode(URL: musicURL!)
            addChild(backgroundMusic)
        }
        
        littleBird = self.childNodeWithName("littleBird") as! SKSpriteNode
        defaultColor = littleBird.color
        
        /* Set UI connections */
            backArrow = self.childNodeWithName("backArrow") as! MSButtonNode
            nextArrow = self.childNodeWithName("nextArrow") as! MSButtonNode
            rainbow = self.childNodeWithName("rainbow") as! MSButtonNode
        
        /* Hide back arrow */
            backArrow.hidden = true
            
        /* Hide next arrow */
            nextArrow.hidden = true
        
        /* Hide rainbow */
            rainbow.hidden = true
            
         /* Set physics contact delegate */
          physicsWorld.contactDelegate = self
        
            /* Last scene button selection handler */
            backArrow.selectedHandler = {
                
                /* Grab reference to our SpriteKit view */
                let skView = self.view as SKView!
                
                /* Load last scene */
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
                /* Next scene button selection handler */
                self.nextArrow.selectedHandler = {
                    
                    /* Grab reference to our SpriteKit view */
                    let skView = self.view as SKView!
                    
                    /* Load next scene */
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
        
                /* Rainbow button selection handler */
                self.rainbow.selectedHandler = {}
            }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        /* Called when a touch begins */
        if threeState != .Active {return}
        
        for child in self.children {
            if child.name == "square"{
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
        if threeState != .Active { return }
        
        /* Called when a touch moves */
        for touch in touches {
            
            let location = touch.locationInNode(self)
            if location.x < 0 || location.y < 0 || location.x > 1344 || location.y > 750{return}
            
            if previousSquare == nil {
                // this is the first square
                let square = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 16, height: 16))
                square.name = "square"
                self.addChild(square)
                square.position = location
                previousSquare = square
            }
            else {
                // connect the previous square to the touch location
                
                let previousLocation = previousSquare!.convertPoint(CGPoint(x: -8, y: 0), toNode: self)
                let diff = location - previousLocation
                
                if diff.length() > 16 {
                    let center = (location + previousLocation) * 0.5
                    
                    let square = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 16, height: 16))
                    square.xScale = diff.length() / 16
                    square.zRotation = -CGFloat(atan2f(Float(diff.x), Float(diff.y))) - CGFloat(M_PI_2)
                    square.name = "square"
                    self.addChild(square)
                    square.position = center
                    previousSquare = square
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Set camera to follow lines */
        if threeState != .Active {return}
        
        littleBird.color = defaultColor
        cameraTarget = littleBird
        littleBird.removeAllActions()
        previousSquare = nil
 
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, littleBird.position.x, littleBird.position.y);
        
        if canDrawPath == true {
            for child in self.children {
                if child.name == "square" {
                    CGPathAddLineToPoint(path, nil, child.position.x, child.position.y + 50);
                }
            }
                let move = SKAction.followPath(path, asOffset:false, orientToPath:false, duration:2.0)
                littleBird.runAction(move)
            }
        }
    
        override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if threeState != .Active {return}
        
        // Camera follows lines
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
        
        /* Ensure only called while game is running */
        if threeState != .Active { return }
        
        if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4 {
            print(contact.bodyA)
            print(contact.bodyB)
            win()
            return
        }
        
        /* Change game state to game over */
        threeState = .GameOver
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view! as SKView
        
        /* Load current scene */
        let scene = ThreeScene(fileNamed:"Three")!
        
        /* Ensure correct aspect mode */
        scene.scaleMode = .AspectFill
        
        /* Restart current scene */
        skView.presentScene(scene)
        littleBird.removeAllActions()
        }

        func win() {
            littleBird.removeAllActions()
            for child in self.children {
                if child.name == "square"{
                    child.removeFromParent()
                }
            }

        threeState = .GameOver
            
        nextArrow.hidden = false; backArrow.hidden = false; rainbow.hidden = false;
        littleBird.removeAllActions()
       
        if musicState == true {
            self.runAction(SKAction.playSoundFileNamed("Winning-sound.wav", waitForCompletion: false))
        }
    }
}