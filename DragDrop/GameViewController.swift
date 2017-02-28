//
//  GameViewController.swift
//  DragDrop
//
//  Created by tkit on 10/16/16.
//  Copyright (c) 2016 Tang Kit. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    
    override func viewWillLayoutSubviews() {
        // Configure the view.
        let skView = self.view as! SKView //
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        // Serialize the JSON here which is an array of dictionary and pass the array to the GameScene

        let jsonFilePath = Bundle.main.path(forResource: "animals", ofType: "json")
        
        let data:NSData = try! NSData(contentsOfFile:jsonFilePath!) // data is the binary. Try the file, but if there are any exceptions, return an error.
        let wordList = try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] //Converts into a dictionary
//        do {
//            if let data = data,
//                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                let blogs = json["blogs"] as? [[String: Any]] {
//                for blog in blogs {
//                    if let name = blog["name"] as? String {
//                        names.append(name)
//                    }
//                }
//            }
//        } catch {
//            print("Error deserializing JSON: \(error)")
//        }
        
//        let scene = GameScene(size: skView.frame.size, wordList:wordList!)

        /* Set the scale mode to scale to fit the window */
//        scene.scaleMode = .aspectFill
        
//        skView.presentScene(scene)
    }

    
    @IBAction func slideValueChanged(_ sender: AnyObject) {
        print("\(slider.value)")
        if let view = self.view as! SKView? {
            let scene = view.scene as! GameScene
            scene.changeLabelAlpha(slider.value)
            scene.playAudio(slider.value)
        }

    }
    
/*    @IBAction func slideValueChanged(sender: Any){
        print("\(slider.value)")
        if let view = self.view as! SKView? {
            let scene = view.scene as! GameScene
            scene.changeLabelAlpha(CGFloat(slider.value))
        }
    }
*/
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
