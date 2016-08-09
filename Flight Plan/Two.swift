//
//  Two.swift
//  Flight Plan
//
//  Created by Cadence on 7/22/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//
import SpriteKit

enum TwoSceneState {
    case Active, GameOver
}

class TwoScene: SKScene, SKPhysicsContactDelegate {
    
    /* Camera helpers */
    var biggerBird: SKSpriteNode!
    var circle: SKSpriteNode!
    var cameraTarget: SKNode!
    
    /* UI Connections */
    var backArrow: MSButtonNode!
    var nextArrow: MSButtonNode!
    var rainbow: MSButtonNode!
    var lastPosition: CGFloat = 0
    var backgroundMusic: SKAudioNode!
    var canDrawPath: Bool!
    var defaultColor: SKColor = SKColor.whiteColor()
    var previousCircle: SKNode?
    
    /* Change game state */
    var twoState: TwoSceneState = .Active
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */
        
        if musicState == true {
            let musicURL = NSBundle.mainBundle().URLForResource("Game-music", withExtension: "mp3")
            backgroundMusic = SKAudioNode(URL: musicURL!)
            addChild(backgroundMusic)
            
        }
        
        biggerBird = childNodeWithName("biggerBird") as! SKSpriteNode
        defaultColor = biggerBird.color
        
        /* Set UI connections */
        backArrow = self.childNodeWithName("backArrow") as! MSButtonNode
        nextArrow = self.childNodeWithName("nextArrow") as! MSButtonNode
        rainbow = self.childNodeWithName("rainbow") as! MSButtonNode
        
        /* Hide back button */
        backArrow.hidden = true
        
        /* Hide next button */
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
        
        /* Next scene button selection handler */
        self.nextArrow.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load next scene */
            let scene = ThreeScene(fileNamed: "Three") as ThreeScene!
            
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
        /* Called when a touch begins */
        if twoState != .Active { return }
        
        for child in self.children {
            if child.name == "circle" {
                child.removeFromParent()
            }
        }

        let location = touches.first!.locationInNode(self)
        if biggerBird.containsPoint(location) {
            // the user is touching the bird
            canDrawPath = true
            biggerBird.color = .grayColor()
        }
        else {
            // the user is not touching the bird; don't start drawing
            canDrawPath = false
        }

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if twoState != .Active { return }
        
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
        /* Set camera to follow lines */
        if twoState != .Active { return }
        
        biggerBird.color = defaultColor
        cameraTarget = circle
        biggerBird.removeAllActions()
        previousCircle = nil
        
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, biggerBird.position.x, biggerBird.position.y);
        
            if canDrawPath == true {
                for child in self.children {
                    if child.name == "circle" {
                        CGPathAddLineToPoint(path, nil, child.position.x, child.position.y + 50);
                    }
                }
                let move = SKAction.followPath(path, asOffset:false, orientToPath:false, duration:2.0)
                biggerBird.runAction(move)
            }
        }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if twoState != .Active { return }
        
        // Camera follows lines
        if let cameraTarget = cameraTarget {camera?.position = cameraTarget.position}
        
        /* Clamp camera scrolling to our visible scene area only */
        camera?.position.x.clamp(180,580)
        
        if biggerBird.position.x < lastPosition{
            biggerBird.xScale = -1
        } else {
            biggerBird.xScale = 1
        }
        
        lastPosition = biggerBird.position.x
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        /* Ensure only called while game is running */
        if twoState != .Active { return }
        
        if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4 {
            print(contact.bodyA)
            print(contact.bodyB)
            win()
            return
        }
        
        /* Change game state to game over */
        twoState = .GameOver
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view! as SKView
        
        /* Load current scene */
        let scene = TwoScene(fileNamed:"Two")!
        
        /* Ensure correct aspect mode */
        scene.scaleMode = .AspectFill
        
        /* Restart current scene */
        skView.presentScene(scene)
        biggerBird.removeAllActions()
    }
    
    func win() {
        biggerBird.removeAllActions()
        for child in self.children {
            if child.name == "circle"{
                child.removeFromParent()
            }
        }
        
        twoState = .GameOver

        nextArrow.hidden = false; backArrow.hidden = false; rainbow.hidden = false;
        biggerBird.removeAllActions()
       
        if musicState == true {
            self.runAction(SKAction.playSoundFileNamed("Winning-sound.wav", waitForCompletion: false))
        }
    }
}
