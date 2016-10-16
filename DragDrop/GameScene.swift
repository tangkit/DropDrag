//
//  GameScene.swift
//  DragDrop
//
//  Created by tkit on 10/16/16.
//  Copyright (c) 2016 Tang Kit. All rights reserved.
//

import SpriteKit

private let kAnimalNodeName = "movable"

class GameScene: SKScene {
    let background = SKSpriteNode(imageNamed: "blue-shooting-stars")
    var selectedNode = SKSpriteNode()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // 1
        self.background.name = "background"
        self.background.anchorPoint = CGPointZero
        // 2
        self.addChild(background)
        
        // 3
        let imageNames = ["bird", "cat", "dog", "turtle"]
        
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = kAnimalNodeName
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count) + 1.0)
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2)
            
            background.addChild(sprite)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as! UITouch
        let positionInScene = touch.locationInNode(self)
        
        selectNodeForTouch(positionInScene)
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        // 1
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            // 2
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                // 3
                if touchedNode.name! == kAnimalNodeName {
                    let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
                        SKAction.rotateByAngle(0.0, duration: 0.1),
                        SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
                    selectedNode.runAction(SKAction.repeatActionForever(sequence))
                }
            }
        }
    }
}


