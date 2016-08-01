////
////  Bonus.swift
////  Flight Plan
////
////  Created by Cadence on 7/22/16.
////  Copyright © 2016 Christine Chan. All rights reserved.
////
//import SpriteKit
//    
//enum BonusSceneState {
//    case Active, GameOver
//}
//    
//    class BonusScene: SKScene, SKPhysicsContactDelegate {
//        
//        /* Camera helpers */
//        var cameraTarget: SKNode!
//        
//        /* UI Connections */
//        var lanternBird: SKSpriteNode!
//        var backArrow: MSButtonNode!
//        var nextArrow: MSButtonNode!
//        var lastPosition: CGFloat = 0
//        var backgroundMusic: SKAudioNode!
//        
//        /* Change game state */
//        var bonusState: BonusSceneState = .Active
//        
//        override func didMoveToView(view: SKView) {
//            /* Set reference to game object connections node */
//            
//            if let musicURL = NSBundle.mainBundle().URLForResource("Calm_music", withExtension: "mp3") {
//                backgroundMusic = SKAudioNode(URL: musicURL)
//                addChild(backgroundMusic)
//            }
//            
//            /* Setup bird character */
//            lanternBird = self.childNodeWithName("lanternBird") as? SKSpriteNode
//            
//            /* Set UI connections */
//            backArrow = self.childNodeWithName("backArrow") as! MSButtonNode
//            nextArrow = self.childNodeWithName("nextArrow") as! MSButtonNode
//            
//            /* Hide back arrow */
//            backArrow.hidden = true
//            
//            /* Hide next arrow */
//            nextArrow.hidden = true
//            
//            /* Set physics contact delegate */
//            physicsWorld.contactDelegate = self
//            
//            /* Last scene button selection handler */
//            backArrow.selectedHandler = {
//                
//                /* Grab reference to our SpriteKit view */
//                let skView = self.view as SKView!
//                
//                /* Load last scene */
//                let scene = ThreeScene(fileNamed: "Three") as ThreeScene!
//                
//                /* Ensure correct aspect mode */
//                scene.scaleMode = .AspectFill
//                
//                /* Show debug */
//                skView.showsPhysics = false
//                skView.showsDrawCount = false
//                skView.showsFPS = false
//                
//                /* Start game scene */
//                skView.presentScene(scene)
//            }
//            
//            /* Next scene button selection handler */
//            self.nextArrow.selectedHandler = {
//                
//                /* Grab reference to our SpriteKit view */
//                let skView = self.view as SKView!
//                
//                /* Load next scene */
//                let scene = BonusScene(fileNamed: "Bonus") as BonusScene!
//                
//                /* Ensure correct aspect mode */
//                scene.scaleMode = .AspectFill
//                
//                /* Show debug */
//                skView.showsPhysics = true
//                skView.showsDrawCount = true
//                skView.showsFPS = true
//                
//                /* Start game scene */
//                skView.presentScene(scene)
//            }
//        }
//        
//        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
//            /* Called when a touch begins */
//            for child in self.children {
//                if child.name == "circle"{
//                    child.removeFromParent()
//                }
//            }
//        }
//        
//        override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//            /* Called when a touch moves */
//            for touch in touches {
//                
//                let location = touch.locationInNode(self)
//                
//                let circle = SKSpriteNode(imageNamed: "Circle")
//                circle.name = "circle"
//                self.addChild(circle)
//                circle.xScale = 0.06
//                circle.yScale = 0.06
//                circle.position = location
//                
//            }
//        }
//        
//        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//            /* Set camera to follow lines */
//            //        cameraTarget = circle
//            //        lanternBird.removeAllActions()
//            
//            let path = CGPathCreateMutable()
//            CGPathMoveToPoint(path, nil, lanternBird.position.x, lanternBird.position.y)
//            
//            for child in self.children {
//                if child.name == "circle"{
//                    CGPathAddLineToPoint(path, nil, child.position.x, child.position.y + 50);
//                }
//            }
//            let move = SKAction.followPath(path, asOffset:false, orientToPath:false, duration:2.0)
//            lanternBird.runAction(move)
//        }
//        
//        override func update(currentTime: CFTimeInterval) {
//            /* Called before each frame is rendered */
//            
//            // Camera follows lines
//            if let cameraTarget = cameraTarget {camera?.position = cameraTarget.position}
//            
//            /* Clamp camera scrolling to our visible scene area only */
//            camera?.position.x.clamp(180,580)
//            
//            if lanternBird.position.x < lastPosition{
//                lanternBird.xScale = 1
//            } else {
//                lanternBird.xScale = -1
//            }
//            
//            lastPosition = lanternBird.position.x
//        }
//        
//        func didBeginContact(contact: SKPhysicsContact) {
//            
//            /* Ensure only called while game is running */
//            if bonusState != .Active { return }
//            
//            if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4 {
//                print(contact.bodyA)
//                print(contact.bodyB)
//                win()
//                return
//            }
//            
//            /* Change game state to game over */
//            bonusState = .GameOver
//            
//            /* Grab reference to our SpriteKit view */
//            let skView = self.view! as SKView
//            
//            /* Load current scene */
//            let scene = BonusScene(fileNamed:"Bonus")!
//            
//            /* Ensure correct aspect mode */
//            scene.scaleMode = .AspectFit
//            
//            /* Restart current scene */
//            skView.presentScene(scene)
//            lanternBird.removeAllActions()
//        }
//        
//        func win() { nextArrow.hidden = false; backArrow.hidden = false
//            lanternBird.removeAllActions()
//            self.runAction(SKAction.playSoundFileNamed("Fanfare.wav", waitForCompletion: true))
//        
//    }
//}
//
