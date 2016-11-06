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
    // this just defines the background node, not  yet added to the view
    let background = SKSpriteNode(imageNamed: "blue-shooting-stars")
    // this selecte node refers to the currently selected node which
    // is picked in the seletNodeForTouch function
    var selectedNode = SKSpriteNode()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 
    override init(size: CGSize) {
        super.init(size: size)
        
        // 1
        self.background.name = "background"
        self.background.anchorPoint = CGPointZero
        // 2 add the defined backgroudn node to the view
        self.addChild(background)
        
        // 3
        let imageNames = ["bird", "cat", "dog", "turtle"]
        
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = kAnimalNodeName
            /**
             We layout the imagenodes horizontally and compute the horizontal spacing between as a fraction of the
             frame width
             */
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count) + 1.0) // Sets the offsetFraction to 20%
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2) //Places the Sprite node in 1/5th increments of the width of the screen
            
            background.addChild(sprite) //adds each of the Sprite nodes to the background scene
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        let touch = touches.first!  // Get hold of the touch object which gives the tapped location info
        let positionInScene = touch.locationInNode(self)
        
        selectNodeForTouch(positionInScene)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let previousPosition = touch.previousLocationInNode(self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        panForTranslation(translation)
    }    
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        // 1
        let touchedNode = self.nodeAtPoint(touchLocation) // Get hold of node at that location
        
        if touchedNode is SKSpriteNode { // Check if the touchedNode is a Sprite Node
            // 2
            if !selectedNode.isEqual(touchedNode) { /** .isEqual same ==, in other words if the selectedNode is a different node from the one I've tapped earlier **/
                
                selectedNode.removeAllActions() // Drop the action that I've defined for the previous tap node
                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1)) //Rotate the node
                
                selectedNode = touchedNode as! SKSpriteNode //Set the selectedNode to the latest tapped node
                
                // 3
                if touchedNode.name! == kAnimalNodeName { // If the touchedNode is actually an Animal, then rotate the node
                    let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
                        SKAction.rotateByAngle(0.0, duration: 0.1),
                        SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
                    selectedNode.runAction(SKAction.repeatActionForever(sequence))
                }
            }
        }
    }
    
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size //This is the size of the whole entire game scene class
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0)) //Which one is the lesser
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        
        if selectedNode.name! == kAnimalNodeName {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        } else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y) //translation refers to the delta or the amount that is moved
            background.position = self.boundLayerPos(aNewPosition)
        }
    }
}



