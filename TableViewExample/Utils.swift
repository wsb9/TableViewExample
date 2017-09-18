//
//  Utils.swift
//  TableViewExample
//
//  Created by Cemen Istomin on 18.09.17.
//  Copyright © 2017 I Love View Inc. All rights reserved.
//

import Foundation
import UIKit

func randomColor(otherThan prevColor: UIColor) -> UIColor {
    let count = 12
    var color = prevColor
    
    // used to generate 100% different adjacent colors
    repeat {
        let hue = CGFloat(arc4random_uniform(UInt32(count))) / CGFloat(count)
        let sat = CGFloat(0.7)
        let bri = CGFloat(0.7)
        color = UIColor(hue: hue, saturation: sat, brightness: bri, alpha: 1)
    } while color == prevColor
    
    return color
}

extension TimeInterval {
    var minutes: TimeInterval { return self * 60 }
    var hours: TimeInterval { return self * 3600 }
    var days: TimeInterval { return self * 86400 }
    var ms:  TimeInterval { return self / 1000.0 }
    
    var minute: TimeInterval { return self.minutes }
    var hour: TimeInterval { return self.hours }
    var day: TimeInterval { return self.days }
    var seconds: TimeInterval { return self }
    var second: TimeInterval { return self }
    
    var gcd: Int64 { return Int64(self * 1_000_000_000) }               // measured in nanoseconds (10^-9)
    var fromNow: Date { return Date(timeIntervalSinceNow: self) }
    var fromNowGCD: DispatchTime { return self.gcd.fromNow }         // unfortunately i didn't found a way to implement fromNow for two return types
}

extension Int64 {
    var fromNow: DispatchTime { return DispatchTime.now() + Double(self) / Double(NSEC_PER_SEC) }
}


func indexPaths(_ indexes: [Int]) -> [IndexPath] {
    return indexes.map { IndexPath(row: $0, section: 0) }
}

func indexPaths(_ range: CountableRange<Int>) -> [IndexPath] {
    let indexes = range.map { $0 }
    return indexPaths(indexes)
}

extension CountableRange where Bound: Integer {
    func shift(by delta: Bound) -> CountableRange<Bound> {
        return lowerBound+delta ..< upperBound+delta
    }
}
