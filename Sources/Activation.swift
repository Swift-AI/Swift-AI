//
//  Activation.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/3/17.
//
//

import Foundation


public extension NeuralNet {
    
    public enum ActivationFunction {
        /// Linear activation function (raw sum).
        case linear
        /// Sigmoid activation function.
        case sigmoid
        /// Rational sigmoid activation function.
        case rationalSigmoid
        /// Hyperbolic tangent activation function.
        case hyperbolicTangent
        /// Custom activation function.
        case custom(activation: (_ x: Float) -> Float, derivative: (_ y: Float) -> Float)
    
        
        // MARK: Initialization
        
        /// Attempts to create an ActivationFunction from a String.
        /// This is used to effectively give each function a raw string,
        /// while bypassing the restriction that Swift enums with associated values cannot have raw values.
        static func from(_ string: String) -> ActivationFunction? {
            switch string {
            case "linear":
                return ActivationFunction.linear
            case "sigmoid":
                return ActivationFunction.sigmoid
            case "rationalSigmoid":
                return ActivationFunction.rationalSigmoid
            case "hyperbolicTangent":
                return ActivationFunction.hyperbolicTangent
            default:
                return nil
            }
        }
        
        /// Returns the raw string value of the ActivationFunction.
        /// This is used to effectively give each function a raw string,
        /// while bypassing the restriction that Swift enums with associated values cannot have raw values.
        func stringValue() -> String {
            switch self {
            case .linear:
                return "linear"
            case .sigmoid:
                return "sigmoid"
            case .rationalSigmoid:
                return "rationalSigmoid"
            case .hyperbolicTangent:
                return "hyperbolicTangent"
            case .custom(_, _):
                return "custom"
            }
        }
        
        
        // MARK: Activation
        
        /// The activation function.
        ///
        /// - Parameter x: The x value at any point along the function.
        /// - Returns: The y value at this point.
        func activation(_ x: Float) -> Float {
            switch self {
            case .linear:
                return x
            case .sigmoid:
                return 1 / (1 + exp(-x))
            case .rationalSigmoid:
                return x / (1 + sqrt(1 + x * x))
            case .hyperbolicTangent:
                return tanh(x)
            case .custom(let activation, _):
                return activation(x)
            }
        }
        
        
        // MARK: Derivative
        
        /// The derivative of the activation function.
        ///
        /// - Parameter y: The y value at any point along the function.
        /// - Returns: The function's derivative at this point.
        func derivative(_ y: Float) -> Float {
            switch self {
            case .linear:
                return 1
            case .sigmoid:
                return y * (1 - y)
            case .rationalSigmoid:
                let x = -(2 * y) / (y * y - 1)
                return 1 / ((x * x) + sqrt((x * x) + 1) + 1)
            case .hyperbolicTangent:
                return 1 - (y * y)
            case .custom(_, let derivative):
                return derivative(y)
            }
        }
        
    }

}
