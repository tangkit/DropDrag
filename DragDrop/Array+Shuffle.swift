//
//  Array+Shuffle.swift
//  DragDrop
//
//  Created by tkit on 12/18/16.
//  Copyright © 2016 Tang Kit. All rights reserved.
//

import Foundation

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

extension Collection {
    /// Return a copy of `self` with its elements shuffled.
    func shuffle() -> [Iterator.Element] { //Generator.Element will loop through our collection and generates 
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}
