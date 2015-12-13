//
//  Random.swift
//  Swift-AI-OSX
//
//  Created by Julio César Guzman on 12/12/15.
//
//

import Foundation

class Random {
    
    static let maximumInteger = UInt32.max
    
    static func random(number : UInt32) -> UInt32 {
        return arc4random_uniform(number)
    }
    
    static func numberFromZeroToOne() -> (Double) {
        return Double(random(maximumInteger))/Double(maximumInteger)
    }
    
    static func randomBounded(min: Double, max: Double) -> Double {
        let amplitude = max - min
        let offset = min
        return offset + amplitude * Random.numberFromZeroToOne()
    }
    
}
