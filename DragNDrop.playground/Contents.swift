//: Playground - noun: a place where people can play

import UIKit

let word = "CAT"
let imageNames = Array(word.characters)



for i in 0..<imageNames.count {
    let imageName = imageNames[i]
    print(imageName)
    print(type(of:imageName))
}


for i in 1...8
{
    print("The image is Cat\(i).png")
}

