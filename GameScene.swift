//
//  GameScene.swift
//  Line Break 2
//
//  Created by Sean Hughes on 4/28/16.
//  Copyright (c) 2016 Sean Hughes. All rights reserved.
//

import SpriteKit
import AudioToolbox

class GameScene: SKScene, SKPhysicsContactDelegate {
    //timer and counter for sprite creation
    var timer = NSTimer()
    var counter = 0
    
    //score stuff
    var myScoreLabel = SKLabelNode(fontNamed: "Helvetica")
    var myScoreNum = 0.0
    var savedScore = 0.0
    
    //highscore
    var highScoreLabel = SKLabelNode(fontNamed: "Helvetica")
    
    //sprites
    var playerOne:SKSpriteNode!
    var touchLocation:CGPoint = CGPointZero
    
    //bools
    var stopMovement:Bool = false
    var startWalls:Bool = false
    var startScore:Bool = false
    
    //position for game over
    var stopPos:CGPoint! = CGPointZero
    
    //var for screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    //opening message label
    let startLabel = UILabel(frame: CGRectMake(0, 0, 300, 50))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        playerOne = self.childNodeWithName("playerOne") as! SKSpriteNode
//        playerOne.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 500)
        self.physicsWorld.contactDelegate = self
        
        //opening text
        startLabel.center = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        startLabel.textAlignment = NSTextAlignment.Center
        startLabel.text = "Touch and Hold Anywhere to Start"
        startLabel.font = startLabel.font.fontWithSize(16)
        startLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(startLabel)
        
        
        //score text
        myScoreLabel.horizontalAlignmentMode = .Left
        myScoreLabel.verticalAlignmentMode = .Top
        myScoreLabel.position = CGPoint(x: self.size.width/2 - 500, y: self.size.height - 75)
        myScoreLabel.text = "Score: " + "\(Int(myScoreNum))"
        myScoreLabel.fontColor = SKColor.whiteColor()
        myScoreLabel.fontSize = CGFloat(50)
        self.addChild(myScoreLabel)
        
        
        //high score text
        highScoreLabel.horizontalAlignmentMode = .Right
        highScoreLabel.position = CGPoint(x: self.size.width/2 + 500, y: self.size.height - 115)
        highScoreLabel.text = "High Score: " + "\(Int(highScoreNum))"
        highScoreLabel.fontColor = SKColor.whiteColor()
        highScoreLabel.fontSize = CGFloat(50)
        self.addChild(highScoreLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        touchLocation = touches.first!.locationInNode(self)
        startWalls = true
        
        startLabel.text = ""
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target:self, selector: #selector(GameScene.updateCounter), userInfo: nil, repeats: true)
        
        startScore = true
        
        let location = (touches.first as? UITouch!)?.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location!)
        
        if (touchedNode.name == "restart") {
            print("touch")
            
            self.removeAllChildren()
            self.removeAllActions()
            
            let game:GameScene = GameScene(fileNamed: "GameScene")!
            game.scaleMode = .AspectFill
            let transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
            self.view?.presentScene(game, transition: transition)
        }
        
        if (touchedNode.name == "menu"){
            let mainmenu:GameScene = GameScene(fileNamed: "MainMenu")!
            mainmenu.scaleMode = .AspectFill
            let transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
            self.view?.presentScene(mainmenu, transition: transition)
        }

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLocation = touches.first!.locationInNode(self)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(stopMovement){
            playerOne.position = stopPos
        } else {
            playerOne.position = touchLocation
        }
        
        if(startScore){
            myScoreNum = myScoreNum + 20
            myScoreLabel.text = "Score: " + "\(Int(myScoreNum))"
            print(myScoreNum)
        } else {
            savedScore = myScoreNum
        }
    
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("Game Over")
        
        stopPos = playerOne.position
        stopMovement = true
        
        //vibrate on collision
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //game over message
        let label = SKLabelNode(fontNamed: "Helvetica")
        label.horizontalAlignmentMode = .Center
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 100)
        label.text = "Game Over!"
        label.fontColor = SKColor.redColor()
        label.fontSize = CGFloat(100)
        self.addChild(label)
        
        //restart button
        let restart = SKLabelNode(fontNamed: "Helvetica")
        restart.name = "restart"
        restart.horizontalAlignmentMode = .Center
        restart.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 100)
        restart.text = "Try Again"
        restart.fontColor = SKColor.whiteColor()
        restart.fontSize = CGFloat(60)
        self.addChild(restart)
        
        let menu = SKLabelNode(fontNamed: "Helvetica")
        menu.name = "menu"
        menu.horizontalAlignmentMode = .Center
        menu.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        menu.text = "Main Menu"
        menu.fontColor = SKColor.whiteColor()
        menu.fontSize = CGFloat(60)
        self.addChild(menu)
        
        startScore = false
        startWalls = false
        
        if(savedScore > highScoreNum){
            highScoreNum = savedScore
            highScoreLabel.text = "High Score: " + "\(Int(highScoreNum))"
        }
        
        //turns off gravity
        physicsWorld.gravity = CGVectorMake(0, 0)
        
    }
    
    func updateCounter() {
        counter += 1
        print(counter)
        makeLines()
        score += 10
    }

    
    
    func makeLines(){
        if(startWalls && startScore){

            let rand = Int(arc4random_uniform(700) + 200)
            //print(rand)
        
            let wall:SKSpriteNode = SKScene(fileNamed: "Wall")!.childNodeWithName("Wall")! as! SKSpriteNode
            wall.removeFromParent()
            self.addChild(wall)
            wall.position = CGPoint(x:rand,y:2000)
            
            if (wall.position.y > screenSize.height) {
                self.removeFromParent();
                print("removed")
            }
            
        }
        
    }
    
    
}
