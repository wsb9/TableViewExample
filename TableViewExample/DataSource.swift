//
//  DataSource.swift
//  TableViewExample
//
//  Created by Cemen Istomin on 18.09.17.
//  Copyright © 2017 I Love View Inc. All rights reserved.
//

import Foundation
import UIKit

protocol DataChangesDelegate: class {
    func items(added: CountableRange<Int>)
    func items(removed: CountableRange<Int>)
}

class DataItem {
    var number: Int = 0
    var color: UIColor = .darkGray
    var height: CGFloat = 44
}

class DataSource {
    var allItems: [DataItem] = []
    var exposedItems: [DataItem] = []
    var exposedRange: CountableRange<Int> = 0..<0
    weak var delegate: DataChangesDelegate? = nil
    
    init(items count: Int) {
        var prevColor = randomColor(otherThan: .white)
        for i in 0 ..< count {
            let item = DataItem()
            item.number = i
            item.color = randomColor(otherThan: prevColor)
            prevColor = item.color
            
            item.height = CGFloat(40 + arc4random_uniform(160))
            allItems.append(item)
        }
    }
    
    private var exposing = false
    func expose(_ new: CountableRange<Int>) {
        guard !exposing else { return }                     // protect from too often calls
        exposing = true
        let new = new.clamped(to: 0 ..< allItems.count)     // protect from out-of-bounds errors
        NSLog("exposing items \(new.lowerBound) ..< \(new.upperBound)")
        
        // small delay to make things noticeable visually
        DispatchQueue.main.asyncAfter(deadline: 0.2.seconds.fromNowGCD) {
            let old = self.exposedRange
            if old.lowerBound > new.lowerBound {
                self.exposedItems.insert(contentsOf: self.allItems[new.lowerBound ..< old.lowerBound], at: 0)
                self.delegate?.items(added: 0 ..< old.lowerBound - new.lowerBound)
            }
            if new.upperBound > old.upperBound {
                let oldCount = self.exposedItems.count
                self.exposedItems.append(contentsOf: self.allItems[old.upperBound ..< new.upperBound])
                self.delegate?.items(added: oldCount ..< self.exposedItems.count)
            }
            
            if old.lowerBound < new.lowerBound {
                let delta = new.lowerBound - old.lowerBound
                self.exposedItems.removeFirst(delta)
                self.delegate?.items(removed: 0 ..< delta)
            }
            if new.upperBound < old.upperBound {
                let delta = old.upperBound - new.upperBound
                let oldCount = self.exposedItems.count
                self.exposedItems.removeLast(delta)
                self.delegate?.items(removed: self.exposedItems.count ..< oldCount)
            }
            
            self.exposedRange = new
            self.exposing = false
        }
    }
    
}
