//
//  Cost.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/3/17.
//
//

import Foundation


public extension NeuralNet {
    
    /// The cost function for calculating error on a single set of validation data.
    public enum CostFunction {
        /// Raw sum error function.
        /// Sum of the absolute values of (real[i] - expected[i])
        case sum
        /// Mean squared error function.
        /// Sum of the squared values of (real[i] - expected[i]), divided by 2n.
        case meanSquared
        /// Cross entropy error function.
        /// Negative sum of (log(real[i]) * expected[i]).
        case crossEntropy
        /// Custom error function.
        case custom((_ real: [Float], _ expected: [Float]) -> Float)
        
        
        // MARK: Calculations
        
        /// The calculated cost (error) for the given validation set.
        func cost(real: [Float], expected: [Float]) -> Float {
            switch self {
            case .sum:
                // Sum of the absolute values of (real[i] - expected[i])
                return zip(real, expected).reduce(0) { (sum, pair) -> Float in
                    return sum + abs(pair.0 - pair.1)
                }
            case .meanSquared:
                // Sum of the squared values of (real[i] - expected[i]), divided by 2n
                let sum = zip(real, expected).reduce(0) { (sum, pair) -> Float in
                    return (pair.0 - pair.1) * (pair.0 - pair.1)
                }
                return sum / Float(2 * real.count)
            case .crossEntropy:
                // Negative sum of (log(real[i]) * expected[i])
                return -zip(real, expected).reduce(0) { (sum, pair) -> Float in
                    return sum + log(pair.0) * pair.1
                }
            case .custom(let function):
                return function(real, expected)
            }
        }
        
    }
    
}
