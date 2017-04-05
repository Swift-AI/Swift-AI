//
//  Structure.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/3/17.
//
//


public extension NeuralNet {
    
    /// A container for the basic structure of a 3-layer neural network.
    public struct Structure {
        
        /// Possible `Structure` errors.
        public enum Error: Swift.Error {
            case initialize(String)
        }
        
        // MARK: Basic structure properties
        
        /// The number of input nodes in the neural network.
        public let inputs: Int
        /// The number of hidden nodes in the neural network.
        public let hidden: Int
        /// The number of output nodes in the neural network.
        public let outputs: Int
        
        // MARK: Pre-computed properties for performance optimization
        
        /// The number of input nodes, INCLUDING the bias node.
        let numInputNodes: Int
        /// The number of hidden nodes, INCLUDING the bias node.
        let numHiddenNodes: Int
        /// The total number of weights connecting all input nodes to all hidden nodes.
        let numHiddenWeights: Int
        /// The total number of weights connecting all hidden nodes to all output nodes.
        let numOutputWeights: Int
        
        
        // MARK: Initialization
        
        public init(inputs: Int, hidden: Int, outputs: Int) throws {
            // Check for valid parameters
            guard inputs > 0, hidden > 0, outputs > 0 else {
                throw Error.initialize("Number of input, hidden and output nodes must be positive and nonzero.")
            }
            
            // Initialize properties
            self.inputs = inputs
            self.hidden = hidden
            self.outputs = outputs
            
            // Compute other properties
            self.numInputNodes = inputs + 1
            self.numHiddenNodes = hidden + 1
            self.numHiddenWeights = (hidden * (inputs + 1))
            self.numOutputWeights = (outputs * (hidden + 1))
        }
        
    }
    
}
