//
//  APMath.swift
//  Copyright © 2015 Appsidian. All rights reserved.
//

import Foundation
import UIKit

/// Converts a UNIX timestamp (in seconds) into an NSDate.
public func dateFromTimestamp(seconds: Int) -> Date {
    return Date(timeIntervalSince1970: TimeInterval(seconds))
}

/// Converts an NSDate into a UNIX timestamp (in seconds).
public func timestampFromDate(date: Date) -> Int {
    return Int(date.timeIntervalSince1970)
}

// TODO: Add documentation and optimize these methods ----------------------------------------
public func progress(_ value: CGFloat, start: CGFloat, end: CGFloat, clamped: Bool) -> CGFloat {
    if start >= 0 {
        let progress = (value - start) / (end - start)
        if clamped && progress < 0 {
            return 0
        } else if clamped && progress > 1 {
            return 1
        } else {
            return progress
        }
    } else {
        let progress = (value - -start) / (end - -start)
        if clamped && progress < 0 {
            return 0
        } else if clamped && progress > 1 {
            return 1
        } else {
            return progress
        }
    }
}


public func transition(_ progress: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat {
    return ((end - start) * progress) + start
}
// END TODO -----------------------------------------------------------------------------------

extension Int {
    
    /// Returns a number equal to the receiver, confined to the given range.
    /// - parameter min: The minimum allowed value
    /// - parameter max: The maximum allowed value
    public func clamp(min: Int, max: Int) -> Int {
        return self < min ? min : (self > max ? max : self)
    }
    
}

extension CGFloat {
    
    /// Returns a number equal to the receiver, confined to the given range.
    /// - parameter min: The minimum allowed value
    /// - parameter max: The maximum allowed value
    public func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        return self < min ? min : (self > max ? max : self)
    }
    
}

extension Float {
    
    /// Returns a number equal to the receiver, confined to the given range.
    /// - parameter min: The minimum allowed value
    /// - parameter max: The maximum allowed value
    public func clamp(min: Float, max: Float) -> Float {
        return self < min ? min : (self > max ? max : self)
    }
    
}

extension Double {
    
    /// Returns a number equal to the receiver, confined to the given range.
    /// - parameter min: The minimum allowed value
    /// - parameter max: The maximum allowed value
    public func clamp(min: Double, max: Double) -> Double {
        return self < min ? min : (self > max ? max : self)
    }
    
    /// Returns the receiver's string representation, truncated to the given number of decimal places.
    /// - parameter decimalPlaces: The maximum number of allowed decimal places
    public mutating func toString(decimalPlaces: Int) -> String {
        let power = pow(10.0, Double(decimalPlaces))
        return "\(Darwin.round(power * self) / power)"
    }
    
}
