//
//  MainMenu.swift
//  Line Break 2
//
//  Created by Sean Hughes on 5/12/16.
//  Copyright © 2016 Sean Hughes. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = (touches.first as? UITouch!)?.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location!)
        
        if (touchedNode.name == "start") {
            print("touch")
            let game:GameScene = GameScene(fileNamed: "GameScene")!
            game.scaleMode = .AspectFill
            let transition:SKTransition = SKTransition.crossFadeWithDuration(1.0)
            self.view?.presentScene(game, transition: transition)
        
        }
    }
}
