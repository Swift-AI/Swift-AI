//
//  Config.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/3/17.
//
//

import Foundation


public extension NeuralNet {
    
    /// Basic configuration settings for `NeuralNet`.
    public struct Configuration {
        
        /// Possible `Configuration` errors.
        public enum Error: Swift.Error {
            case initialize(String)
        }
        
        /// The activation function to use for inference.
        let activation: ActivationFunction
        /// The learning rate to apply during training.
        let learningRate: Float
        /// The momentum factor to apply during training.
        let momentumFactor: Float
        
        init(activation: ActivationFunction, learningRate: Float, momentum: Float) throws {
            // Ensure valid parameters
            guard learningRate >= 0 && momentum >= 0 else {
                throw Error.initialize("Learning rate and momentum must be positivie.")
            }
            
            // Initialize properties
            self.activation = activation
            self.learningRate = learningRate
            self.momentumFactor = momentum
        }
        
    }
    
}
