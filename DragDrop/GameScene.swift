//
//  GameScene.swift
//  DragDrop
//
//  Created by tkit on 10/16/16.
//  Copyright (c) 2016 Tang Kit. All rights reserved.
//

import SpriteKit
import UIKit

private let alphabetLetter = "movable"

class GameScene: SKScene {
    // this just defines the background node, not  yet added to the view
    let background = SKSpriteNode(imageNamed: "blue-shooting-stars")
    // this selected node refers to the currently selected node which
    // is picked in the selectNodeForTouch function
    var audioIndex:Int = 0
    let audioNode1 = SKAudioNode(fileNamed:"ck.mp3")
    let audioNode2 = SKAudioNode(fileNamed:"a.mp3")
    let audioNode3 = SKAudioNode(fileNamed:"t.mp3")
    var audioNodes = [SKAudioNode]()
    var selectedNode = SKSpriteNode()
    var placeholderNodes:NSMutableArray = []
    var lockedNodes:NSMutableArray = []
    var lockedCharacters:NSMutableArray = []
    var letterCount = 0
    var vectorAnimationNode = SKSpriteNode()
    var word:String
    var randomWordData:[String:String]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(size: CGSize, wordList: [[String:String]]) {
        //self.word = word STEP 2: Pick a word randomly from wordList
        self.randomWordData = wordList[0]
        self.word = randomWordData["name"]!
        let phonetics:[String] = [randomWordData["phonetics"]!]
        
        for phonetic in phonetics {
               let audioNode = SKAudioNode(fileNamed:"\(phonetic).mp3")
            audioNodes.append(audioNode)
        }
            
        super.init(size: size)

        // 1
        self.background.name = "background"
        self.background.anchorPoint = CGPoint.zero // This means anchorPoint is (0,0)?
    
        // 2 add the defined background node to the view
//        self.addChild(background)
        vectorAnimationNode = SKSpriteNode(imageNamed: "\(word)1.png")
        
        vectorAnimationNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.75) //Places the vector Sprite node in 1/5th increments of the width of the screen
        vectorAnimationNode.setScale(0.25)
        self.addChild(vectorAnimationNode)
        
        self.audioNodes.append(audioNode1)
        self.audioNodes.append(audioNode2)
        self.audioNodes.append(audioNode3)
        
        // 3
        // let us assume that you have A.png, B.png, ..., Z..png available in your Assets.xcassets
        // split the input word into individual upper casset leterers
        // let letters = ['D', 'U', 'C', 'K'] ==> ssplit string into indivi letters
        // let imageNames = ['K', 'U', D', 'C']
        // let imageNames = ["bird", "cat", "dog", "turtle"]
        
        var imageNames = Array(word.characters).shuffle() //word is populated in the initializer, for instance CAT is broken up into C, A, T
        
        // print ("imageNames: \(imageNames)")

         // imageNames.shuffleInPlace()
        
        letterCount = imageNames.count //The number of letters is the number of elements in the array

        for i in 0..<imageNames.count {
            let imageName = String(imageNames[i]) //String will convert each character into a string
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            
            sprite.name = imageName
            /**
             We layout the imagenodes horizontally and compute the horizontal spacing between as a fraction of the
             frame width
             */
            
            sprite.setScale(0.5)
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count) + 1.0) // Sets the offsetFraction to 20%
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height / 4) //Places the Sprite node in 1/5th increments of the width of the screen
            
            self.addChild(sprite) //adds each of the Sprite nodes to the background scene
            
            // now i will add a placehodler
            
          
            let underLinePlaceholder = SKSpriteNode(imageNamed: "line")
            underLinePlaceholder.setScale(0.25)
            underLinePlaceholder.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2.5) //Places the Sprite node in 1/5th increments of the width of the screen
            self.addChild(underLinePlaceholder)
            placeholderNodes.add(underLinePlaceholder) //Adding placeholder to the placeholderNodes array
            
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touch = touches.first!  // Get hold of the touch object which gives the tapped location info
        let positionInScene = touch.location(in: self) //touch.locationInNode(self) converts to the SpriteKit coordinate system
        
        selectNodeForTouch(positionInScene) //Calls the selectNodeForTouch function with the positionInScene input coorindates
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if lockedNodes.contains(selectedNode) {

            print(selectedNode.texture!.description)

            if lockedNodes.count == letterCount {
                let sortedNodes = lockedNodes.sorted(){
                    let s0:SKSpriteNode = $0 as! SKSpriteNode
                    let s1:SKSpriteNode = $1 as! SKSpriteNode
                    return s0.position.x < s1.position.x
                }
                print("Placeholder: \(placeholderNodes)")
                print("LockedNodes: \(lockedNodes)")
                print("SortedLockNodes: \(sortedNodes)")
                
                let outputWordChars = sortedNodes.map{($0 as! SKSpriteNode).name!}
                print("Print outputWordChars: \(outputWordChars)")
                
                let outputWord:String = (outputWordChars as NSArray).componentsJoined(by: "")
                
                print ("outputWord: \(outputWord)")
                
                if   outputWord == self.word {
                    showAnimatedObject()
                }
                
            }
            
            return
            // for each placeholderNode index, look up the selected node placed there in the list of locked nodes
            //  on screen: T C A
            //  locked nodes [T C A]
             // make the string "TCA" and compare with world 'CAT' if matches then right else wrong
    
        }
        
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        // if list of locked nodes doe snot coantain the selected node then plan for tanslation
        panForTranslation(translation)
        
        // now i will do the intersection tests
        
        // for each placehodler node in all placeholders:
        //      check if selected nod einterseect with plachodler
        //  if intersects:
        //        update selectenode position with placehodle r node bpostion
        //         remvoe placeholder node form list o fall placehodlers
        //         add the slected node to a lis to of lock ned nodes
        for placeholderNode in placeholderNodes {
            if (placeholderNode as AnyObject).intersects(selectedNode) {
                selectedNode.position = CGPoint(x: (placeholderNode as AnyObject).position.x, y: (placeholderNode as AnyObject).position.y*1.25)
                placeholderNodes.remove(placeholderNode)
                // print("intersected")
                // print("This is debug output \(selectedNode.texture!)")
                lockedNodes.add(selectedNode)
//                let index = placeholderNodes.indexOfObject(placeholderNode)
//                 lockedNodes.insertObject(selectedNode, atIndex: index)
                // lockedCharacters.addObject(selectedNode)
            }
        }
    }
    
    
    func degToRad(_ degree: CGFloat) -> CGFloat {
        return (degree / CGFloat(180.0 * M_PI))
    }
    
    func selectNodeForTouch(_ touchLocation: CGPoint) {
        // 1
        let touchedNode = self.atPoint(touchLocation) // Get hold of node at that location
        
        if touchedNode is SKSpriteNode { // Check if the touchedNode is a Sprite Node
            // 2
            if !selectedNode.isEqual(touchedNode) { /** .isEqual same ==, in other words if the selectedNode is a different node from the one I've tapped earlier **/
                
                selectedNode.removeAllActions() // Drop the action that I've defined for the previous tap node
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1)) //Rotate the node
                
                selectedNode = touchedNode as! SKSpriteNode //Set the selectedNode to the latest tapped node
                
                // 3
                if  self.word.range(of: touchedNode.name!) != nil { // If the touchedNode is actually a substring of word, then rotate the node
                    let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(-4.0), duration: 0.1),
                        SKAction.rotate(byAngle: 0.0, duration: 0.1),
                        SKAction.rotate(byAngle: degToRad(4.0), duration: 0.1)])
                    selectedNode.run(SKAction.repeatForever(sequence))
                }
            }
        }
    }
    
    func boundLayerPos(_ aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size //This is the size of the whole entire game scene class
        var retval = aNewPosition
        print("\(retval.x)")
        retval.x = CGFloat(min(retval.x, 0)) //Which one is the lesser
        print("\(retval.x)")
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        print("\(-background.size.width + winSize.width)")
        print("\(retval.x)")
        
        retval.y = self.position.y
        print("\(retval.y)")
        
        return retval
    }
    
    func panForTranslation(_ translation: CGPoint) {
        let position = selectedNode.position
        
            if self.word.range(of: selectedNode.name!) != nil { // self.word.rangeOfString (selectedNode.name) checks if the selectedNode.name is a substring of self.word ; ie. if T is the selectedNode.name then T is a substring of CAT and hence you can drag
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y) //the selectedNode.position is the current position, but it gets re-drawn/redefined to the new translated position/coordinates
        }
        
     /*   else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y) //if it's not an alphabet letter that you dragged, then you move the background accordingly
            background.position = self.boundLayerPos(aNewPosition)
        }
        */
    }
    
    func showAnimatedObject() {
        var animationFrames:[SKTexture]=[]
        for i in 1...8
        {
            let animationTexture:SKTexture = SKTexture(imageNamed: "\(word)\(i).png")
            animationFrames.append(animationTexture)
        }
        vectorAnimationNode.run(SKAction.repeatForever(SKAction.animate(with: animationFrames, timePerFrame: 0.1)))
    }
    
    func playAudioAtNode() {
        let aNode = self.audioNodes[self.audioIndex]
        self.addChild(aNode)
        aNode.run(SKAction.play())
    }
    
    func playAudio(_ sliderValue:Float){
        print("playing audio")
        if(sliderValue > 0) {
            // play cat
            if (self.audioIndex == 0) {
                self.playAudioAtNode()
                self.audioIndex = self.audioIndex + 1 //?
            }
            
        }
        if (sliderValue > 0.33)
        {
            // play a
            if (self.audioIndex == 1) {
                self.playAudioAtNode()
                self.audioIndex = self.audioIndex + 1 //?
            }
        }
        if (sliderValue > 0.66) {
            // play t
            if (self.audioIndex == 2) {
                self.playAudioAtNode()
                self.audioIndex = self.audioIndex + 1 //?
            }
        }
        
    }
    
    
    func changeLabelAlpha(_ sliderValue:Float)
    {
        print("\(sliderValue)")
        // change the aplha value of each placeholder node
        // mean i s0.16
        // 0 and 0.33 --> scale C up and down, index = 0, min
        // 0.33 and 0.66 --> scale A up and down, index = 1
        // 0.66 and 1 --> scale T up an down, index = 2
        // C, A, T are locked nodes with indices 0. 1 . 2
        // example: value is between 0 and 0.16 (0.08) (1/2 of 0.16) is 50%, 0.5, 1 + 0.5, ==> 1.5
        // value is  between 0.15 and 0. (0.30) (0.14 = 0.30 - 0.16) (0.8) (2 - 0.8) ==> 1.2
        var index:Int = 0
        var scaleValue:Float = 1.0
        if sliderValue > 0.0 && sliderValue < 0.33 {
            index = 0
            if sliderValue < 0.16 {
                scaleValue = (sliderValue / 0.16) + 0.5
            } else {
                scaleValue = 2.0 - (sliderValue - 0.16)/0.16
            }
        }
        // SKAction.run{SKAction.playSoundFileNamed("ck.mp3", waitForCompletion: false)}
       
        if sliderValue > 0.33 && sliderValue < 0.66 {
            let lockedNode:SKSpriteNode = lockedNodes.object(at: 0) as! SKSpriteNode
            lockedNode.yScale = 1.0
        }
        print("\(scaleValue)")
        let lockedNode:SKSpriteNode = lockedNodes.object(at: index) as! SKSpriteNode
        lockedNode.yScale = CGFloat(scaleValue)
    }
}

