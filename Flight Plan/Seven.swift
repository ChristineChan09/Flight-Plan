//
//  Six.swift
//  Flight Plan
//
//  Created by Cadence on 8/04/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//
import SpriteKit

enum SevenSceneState {
    case Active, GameOver
}

class SevenScene: SKScene, SKPhysicsContactDelegate {
    
    /* Camera helpers */
    var cameraTarget: SKNode!
    var circle: SKSpriteNode!
    
    /* UI Connections */
    var lanternBird: SKSpriteNode!
    var backArrow: MSButtonNode!
    var homeButton: MSButtonNode!
    var rainbow: MSButtonNode!
    var lastPosition: CGFloat = 0
    var backgroundMusic: SKAudioNode!
    var Tutorial: SKLabelNode!
    var canDrawPath: Bool!
    var defaultColor: SKColor = SKColor.whiteColor()
    var previousCircle: SKNode?
    
    /* Change game state */
    var sevenState: SevenSceneState = .Active
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */

        if musicState == true {
            let musicURL = NSBundle.mainBundle().URLForResource("Game-music", withExtension: "mp3")
            backgroundMusic = SKAudioNode(URL: musicURL!)
            
            addChild(backgroundMusic)
        }

        /* Setup bird character */
        lanternBird = self.childNodeWithName("lanternBird") as! SKSpriteNode
        defaultColor = lanternBird.color
        
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
            let scene = SixScene(fileNamed: "Six") as SixScene!
            
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
        rainbow.selectedHandler = {}
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        /* Called when a touch begins */
        if sevenState != .Active {return}
        
        for child in self.children {
            if child.name == "circle"{
                child.removeFromParent()
            }
        }
        
        let location = touches.first!.locationInNode(self)
        if lanternBird.containsPoint(location) {
            // player is touching the bird, start drawing
            canDrawPath = true
            lanternBird.color = .orangeColor()
        }
        else {
            // player is not touching the bird; don't start drawing
            canDrawPath = false
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if sevenState != .Active { return }
        
        /* Called when a touch moves */
        for touch in touches {
            
            let location = touch.locationInNode(self)
            if location.x < 0 || location.y < 0 || location.x > 1344 || location.y > 750
            {return}
            
            if previousCircle == nil {
                // this is the first circle
                let circle = SKSpriteNode(color: SKColorWithRGB(255, g: 255, b: 102), size: CGSize(width: 16, height: 16))
                circle.name = "circle"
                circle.color = SKColorWithRGB(255, g: 255, b: 102)
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
                    
                    let circle = SKSpriteNode(color: SKColorWithRGB(255, g: 255, b: 102), size: CGSize(width: 16, height: 16))
                    circle.xScale = diff.length() / 16
                    circle.zRotation = -CGFloat(atan2f(Float(diff.x), Float(diff.y))) - CGFloat(M_PI_2)
                    circle.name = "circle"
                    circle.color = SKColorWithRGB(255, g: 255, b: 102)
                    self.addChild(circle)
                    circle.position = center
                    previousCircle = circle
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Set camera to follow lines */
        if sevenState != .Active {return}
        
        lanternBird.color = defaultColor
        cameraTarget = lanternBird
        lanternBird.removeAllActions()
        previousCircle = nil
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, lanternBird.position.x, lanternBird.position.y);
        
        if canDrawPath == true {
            for child in self.children {
                if child.name == "circle" {
                    CGPathAddLineToPoint(path, nil, child.position.x, child.position.y + 35);
                }
            }
            let move = SKAction.followPath(path, asOffset:false, orientToPath:false, duration:2.0)
            lanternBird.runAction(move)
            
        }
    }
    
    func updateCamera() {
        if let camera = camera {
            camera.position = CGPoint(x: lanternBird!.position.x, y: lanternBird!.position.y)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if sevenState != .Active {return}
        
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
        if sevenState != .Active { return }
        
        if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4 {
            print(contact.bodyA)
            print(contact.bodyB)
            win()
            return
        }
        
        /* Change game state to game over */
        sevenState = .GameOver
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view! as SKView
        
        /* Load current scene */
        let scene = SevenScene(fileNamed:"Seven")as SevenScene!
        
        /* Ensure correct aspect mode */
        scene.scaleMode = .AspectFill
        
        /* Restart current scene */
        skView.presentScene(scene)
        lanternBird.removeAllActions()
    }
    
    func win() {
        lanternBird.removeAllActions()
        for child in self.children {
            if child.name == "circle"{
                child.removeFromParent()
            }
        }
        
        sevenState = .GameOver
        
        backArrow.hidden = false; homeButton.hidden = false; rainbow.hidden = false;
        lanternBird.removeAllActions()
       
        if musicState == true {
            self.runAction(SKAction.playSoundFileNamed("Winning-sound.wav", waitForCompletion: false))
        }
    }
}