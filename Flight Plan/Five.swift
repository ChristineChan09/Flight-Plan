//
//  Six
//  Flight Plan
//
//  Created by Cadence on 8/04/16.
//  Copyright © 2016 Christine Chan. All rights reserved.
//
import SpriteKit
    
enum FiveSceneState {
    case Active, GameOver
}
    
class FiveScene: SKScene, SKPhysicsContactDelegate {
    
    /* UI Connections */
    var tinyBird: SKSpriteNode!
    var square: SKSpriteNode!
    
    var backArrow: MSButtonNode!
    var nextArrow: MSButtonNode!
    var rainbow: MSButtonNode!
    var lastPosition: CGFloat = 0
    var backgroundMusic: SKAudioNode!
    var canDrawPath: Bool!
    var defaultColor: SKColor = SKColor.whiteColor()
    var previousSquare: SKNode?
    
    /* Change game state */
    var fiveState: FiveSceneState = .Active
    
    override func didMoveToView(view: SKView) {
        /* Set reference to game object connections node */
        
        if musicState == true {
            let musicURL = NSBundle.mainBundle().URLForResource("Game-music", withExtension: "mp3")
            backgroundMusic = SKAudioNode(URL: musicURL!)
            
            addChild(backgroundMusic)
        }
            
        /* Setup bird character */
        tinyBird = self.childNodeWithName("tinyBird") as? SKSpriteNode
        defaultColor = tinyBird.color
        
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
            let scene = FourScene(fileNamed: "Four") as FourScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
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
            let scene = SixScene(fileNamed: "Six") as SixScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
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
        if fiveState != .Active {return}
        
        for child in self.children {
            if child.name == "square"{
                child.removeFromParent()
            }
        }
        
        let location = touches.first!.locationInNode(self)
        if tinyBird.containsPoint(location) {
            // the user is touching the bird
            canDrawPath = true
            tinyBird.color = .grayColor()
        }
        else {
            // the user is not touching the bird; don't start drawing
            canDrawPath = false
        }
    }
        
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if fiveState != .Active { return }
        
        /* Called when a touch moves */
        for touch in touches {
            
            let location = touch.locationInNode(self)
            if location.x < 0 || location.y < 0 || location.x > 1344 || location.y > 750
            {return}
            
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
        if fiveState != .Active {return}
        
        tinyBird.color = defaultColor
        tinyBird.removeAllActions()
        previousSquare = nil
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, tinyBird.position.x, tinyBird.position.y);
        
        if canDrawPath == true {
            for child in self.children {
                if child.name == "square" {
                    CGPathAddLineToPoint(path, nil, child.position.x, child.position.y + 50);
                }
            }
            let move = SKAction.followPath(path, asOffset:false, orientToPath:false, duration:2.0)
            tinyBird.runAction(move)
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
         if fiveState != .Active {return}
        
        if tinyBird.position.x < lastPosition{
            tinyBird.xScale = 1
        } else {
            tinyBird.xScale = -1
        }
        
        lastPosition = tinyBird.position.x
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        /* Ensure only called while game is running */
        if fiveState != .Active { return }
        
        if contact.bodyA.categoryBitMask == 2 || contact.bodyB.categoryBitMask == 2 {
                    
            /* Change game state to game over */
            
            fiveState = .GameOver
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view! as SKView
            
            /* Load current scene */
            let scene = FiveScene(fileNamed:"Five")!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Restart current scene */
            skView.presentScene(scene)
            tinyBird.removeAllActions()

        }
       
        if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4 {
            print(contact.bodyA)
            print(contact.bodyB)
            win()
            return
        }
        if contact.bodyA.categoryBitMask == 3 {
            contact.bodyA.node!.runAction(SKAction.moveBy(CGVectorMake(28, 0), duration: 2))
            
            tinyBird.removeAllActions()
        }
    }
    
    func win() {
        tinyBird.removeAllActions()
        for child in self.children {
            if child.name == "square"{
                child.removeFromParent()
            }
        }
        
        fiveState = .GameOver
        
        nextArrow.hidden = false; backArrow.hidden = false; rainbow.hidden = false;
        tinyBird.removeAllActions()
        
        if musicState == true {
            self.runAction(SKAction.playSoundFileNamed("Winning-sound.wav", waitForCompletion: false))
        }
    }
}

