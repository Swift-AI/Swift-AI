//
//  NeuralNet.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/3/17.
//
//

import Foundation
import Accelerate


/// A 3-layer, feed-forward artificial neural network.
public final class NeuralNet {
    
    // MARK: Errors
    
    /// Possible errors that may be thrown by `NeuralNet`.
    public enum Error: Swift.Error {
        case initialization(String)
        case weights(String)
        case inference(String)
        case train(String)
    }
    
    // MARK: Public properties

    /// The basic structure of the neural network (read-only).
    /// This includes the number of input, hidden and output nodes.
    public let structure: Structure
    
    /// The activation function to apply during inference (read-only).
    public var activationFunction: ActivationFunction

    /// The 'learning rate' parameter to apply during backpropagation.
    /// This property may be safely mutated at any time.
    public var learningRate: Float {
        // Must update mfLR whenever this property is changed
        didSet(newRate) {
            cache.mfLR = (1 - momentumFactor) * newRate
        }
    }
    
    /// The 'momentum factor' to apply during backpropagation.
    /// This property may be safely mutated at any time.
    public var momentumFactor: Float {
        // Must update mfLR whenever this property is changed
        didSet(newMomentum) {
            cache.mfLR = (1 - newMomentum) * learningRate
        }
    }
    
    
    // MARK: Private properties and caches
    
    /// A set of pre-computed values and caches used internally for performance optimization.
    fileprivate var cache: Cache
    
    
    // MARK: Initialization
    
    public init(structure: Structure, config: Configuration, weights: [Float]? = nil) throws {
        // Initialize basic properties
        self.structure = structure
        self.activationFunction = config.activation
        self.learningRate = config.learningRate
        self.momentumFactor = config.momentumFactor
        
        // Initialize computed properties and caches
        self.cache = Cache(structure: structure, config: config)
        
        // Set initial weights, or randomize if none are provided
        if let weights = weights {
            try self.setWeights(weights)
        } else {
            randomizeWeights()
        }
    }
    
}


// MARK: Weights

public extension NeuralNet {
    
    /// Resets the network with the given weights (i.e. from a pre-trained network).
    /// This change may safely be performed at any time.
    ///
    /// - Parameter weights: A serialized array of `Float`, to be used as hidden *and* output weights for the network.
    /// - IMPORTANT: The number of weights must equal `hidden * (inputs + 1) + outputs * (hidden + 1)`, or the weights will be rejected.
    public func setWeights(_ weights: [Float]) throws {
        // Ensure valid number of weights
        guard weights.count == structure.numHiddenWeights + structure.numOutputWeights else {
            throw Error.weights("Invalid number of weights provided: \(weights.count). Expected: \(structure.numHiddenWeights + structure.numOutputWeights).")
        }
        // Reset all weights in the network
        cache.hiddenWeights = Array(weights[0..<structure.numHiddenWeights])
        cache.outputWeights = Array(weights[structure.numHiddenWeights..<weights.count])
    }
    
    /// Returns a serialized array of the network's current weights.
    public func allWeights() -> [Float] {
        return cache.hiddenWeights + cache.outputWeights
    }
    
    /// Randomizes all of the network's weights.
    fileprivate func randomizeWeights() {
        // Randomize hidden weights.
        for i in 0..<structure.numHiddenWeights {
            cache.hiddenWeights[i] = randomHiddenWeight()
        }
        for i in 0..<structure.numOutputWeights {
            cache.outputWeights[i] = randomOutputWeight()
        }
    }
    
    
    // TODO: Generate random weights along a normal distribution, rather than a uniform distribution.
    // Also, these weights are optimized for sigmoid activation.
    // Alternatives should be considered for other activation functions.
    
    /// Generates a random weight for a hidden node, based on the parameters set for the network.
    fileprivate func randomHiddenWeight() -> Float {
        // Note: Hidden weight distribution depends on number of *input* nodes
        return randomWeight(layerInputs: structure.numInputNodes)
    }
    
    /// Generates a random weight for an output node, based on the parameters set for the network.
    fileprivate func randomOutputWeight() -> Float {
        // Note: Output weight distribution depends on number of *hidden* nodes
        return randomWeight(layerInputs: structure.numHiddenNodes)
    }
    
    /// Generates a single random weight.
    ///
    /// - Parameter layerInputs: The number of inputs to the layer in which this weight will be used.
    /// E.g., if this weight will be placed in the hidden layer, `layerInputs` should be the number of input nodes (including bias node).
    /// - Returns: A randomly-generated weight optimized for this layer.
    private func randomWeight(layerInputs: Int) -> Float {
        let range = 1 / sqrt(Float(layerInputs))
        let rangeInt = UInt32(2_000_000 * range)
        let randomFloat = Float(arc4random_uniform(rangeInt)) - Float(rangeInt / 2)
        return randomFloat / 1_000_000
    }
    
}


// MARK: Inference

public extension NeuralNet {
    
    // Note: The inference method is somewhat complex, but testing has shown that
    // keeping the code in-line allows the Swift compiler to make better optimizations.
    // Thus, we achieve improved performance at the cost of slightly less readable code.
    
    /// Inference: propagates the given inputs through the neural network, returning the network's output.
    /// This is the typical method for 'using' a trained neural network.
    /// This is also used during the training process.
    ///
    /// - Parameter inputs: An array of `Float`, each element corresponding to one input node.
    /// - Returns: The network's output after applying the given inputs.
    /// - Throws: An error if an incorrect number of inputs is provided.
    /// - IMPORTANT: The number of inputs provided must exactly match the network's number of inputs (defined in its `Structure`).
    @discardableResult
    public func infer(_ inputs: [Float]) throws -> [Float] {
        // Ensure that the correct number of inputs is given
        guard inputs.count == structure.inputs else {
            throw Error.inference("Invalid number of inputs provided: \(inputs.count). Expected: \(structure.inputs).")
        }
        
        // Cache the inputs
        // Note: A bias node is inserted at index 0, followed by all of the given inputs
        cache.inputCache[0] = 1
        // Note: This loop appears to be the fastest way to make this happen
        for i in 1..<structure.numInputNodes {
            cache.inputCache[i] = inputs[i - 1]
        }
        
        // Calculate the weighted sums for the hidden layer
        vDSP_mmul(cache.hiddenWeights, 1,
                  cache.inputCache, 1,
                  &cache.hiddenOutputCache, 1,
                  vDSP_Length(structure.hidden),
                  vDSP_Length(1),
                  vDSP_Length(structure.numInputNodes))
        
        // Apply the activation function to the hidden layer nodes
        for i in (1...structure.hidden).reversed() {
            // Note: Array elements are shifted one index to the right, in order to efficiently insert the bias node at index 0
            cache.hiddenOutputCache[i] = activationFunction.activation(cache.hiddenOutputCache[i - 1])
        }
        cache.hiddenOutputCache[0] = 1
        
        // Calculate the weighted sum for the output layer
        vDSP_mmul(cache.outputWeights, 1,
                  cache.hiddenOutputCache, 1,
                  &cache.outputCache, 1,
                  vDSP_Length(structure.outputs),
                  vDSP_Length(1),
                  vDSP_Length(structure.numHiddenNodes))
        
        // Apply the activation function to the output layer nodes
        for i in 0..<structure.outputs {
            cache.outputCache[i] = activationFunction.activation(cache.outputCache[i])
        }
        
        // Return the final outputs
        return cache.outputCache
    }
    
}


// MARK: Training

public extension NeuralNet {
    
    // Note: The backpropagation method is somewhat complex, but testing has shown that
    // keeping the code in-line allows the Swift compiler to make better optimizations.
    // Thus, we achieve improved performance at the cost of slightly less readable code.
    
    /// Applies modifications to the neural network by comparing its most recent output to the given `labels`, adjusting the network's weights as needed.
    /// This method should be used for training a neural network manually.
    ///
    /// - Parameter labels: The 'correct' desired output for the most recent inference cycle, as an array of `Float`.
    /// - Returns: The total calculated error from the most recent inference.
    /// - Throws: An error if an incorrect number of outputs is provided.
    /// - IMPORTANT: The number of labels provided must exactly match the network's number of outputs (defined in its `Structure`).
    @discardableResult
    public func backpropagate(_ labels: [Float]) throws -> Float {
        // Ensure that the correct number of outputs was given
        guard labels.count == structure.outputs else {
            throw Error.train("Invalid number of labels provided: \(labels.count). Expected: \(structure.outputs).")
        }
        
        // Calculate output errors
        for (index, output) in cache.outputCache.enumerated() {
            cache.outputErrorsCache[index] = activationFunction.derivative(output) * (labels[index] - output)
        }
        
        // Calculate hidden errors
        vDSP_mmul(cache.outputErrorsCache, 1,
                  cache.outputWeights, 1,
                  &cache.hiddenErrorSumsCache, 1,
                  vDSP_Length(1),
                  vDSP_Length(structure.numHiddenNodes),
                  vDSP_Length(structure.outputs))
        
        for (index ,error) in cache.hiddenErrorSumsCache.enumerated() {
            cache.hiddenErrorsCache[index] = activationFunction.derivative(cache.hiddenOutputCache[index]) * error
        }
        
        // Update output weights
        for index in 0..<structure.numOutputWeights {
            let offset = cache.outputWeights[index] + (momentumFactor * (cache.outputWeights[index] - cache.previousOutputWeights[index]))
            let errorIndex = cache.outputErrorIndices[index]
            let hiddenOutputIndex = cache.hiddenOutputIndices[index]
            let mfLRErrIn = cache.mfLR * cache.outputErrorsCache[errorIndex] * cache.hiddenOutputCache[hiddenOutputIndex]
            cache.newOutputWeights[index] = offset + mfLRErrIn
        }
        
        // Efficiently copy output weights from current to 'previous' array
        vDSP_mmov(cache.outputWeights,
                  &cache.previousOutputWeights, 1,
                  vDSP_Length(structure.numOutputWeights),
                  1, 1)
        
        // Copy output weights from 'new' to current array
        vDSP_mmov(cache.newOutputWeights,
                  &cache.outputWeights, 1,
                  vDSP_Length(structure.numOutputWeights),
                  1, 1)
        
        // Update hidden weights
        for index in 0..<structure.numHiddenWeights {
            let offset = cache.hiddenWeights[index] + (momentumFactor * (cache.hiddenWeights[index] - cache.previousHiddenWeights[index]))
            let errorIndex = cache.hiddenErrorIndices[index]
            let inputIndex = cache.inputIndices[index]
            // Note: +1 on errorIndex to offset for bias 'error', which is ignored
            let mfLRErrIn = cache.mfLR * cache.hiddenErrorsCache[errorIndex + 1] * cache.inputCache[inputIndex]
            cache.newHiddenWeights[index] = offset + mfLRErrIn
        }
        
        // Copy hidden weights from current to 'previous' array
        vDSP_mmov(cache.hiddenWeights,
                  &cache.previousHiddenWeights, 1,
                  vDSP_Length(structure.numHiddenWeights),
                  1, 1)
        
        // Copy hidden weights from 'new' to current array
        vDSP_mmov(cache.newHiddenWeights,
                  &cache.hiddenWeights, 1,
                  vDSP_Length(structure.numHiddenWeights),
                  1, 1)
        
        // Sum and return the output errors
        return cache.outputErrorsCache.reduce(0, {$0 + abs($1)})
    }
    
    
    /// Attempts to train the neural network using the given dataset.
    ///
    /// - Parameters:
    ///   - data: A `Dataset` containing training and validation data, used to train the network.
    ///   - cost: The cost function to use while calculating error, in order to determine network progress.
    ///   - errorThreshold: The minimum acceptable error, as calculated by `cost`. This error will be calculated on the validation set at the end of each training epoch. Once the error has dropped below `errorThreshold`, training will cease and return. This value must be determined by the user, as it varies based on the type of data and desired accuracy.
    /// - Returns: A serialized array containing the network's final weights, as calculated during the training process.
    /// - Throws: An error if invalid data is provided. Checks are performed in advance to avoid problems during the training cycle.
    /// - WARNING: `errorThreshold` should be considered carefully. A value too high will produce a poorly-performing network, while a value too low (i.e. too accurate) may be unachievable, resulting in an infinite training process.
    public func train(_ data: Dataset, cost: CostFunction, errorThreshold: Float) throws -> [Float] {
        // Ensure valid error threshold
        guard errorThreshold > 0 else {
            throw Error.train("Training error threshold must be greater than zero.")
        }
        
        // -----------------------------
        // TODO: Allow the trainer to exit early or regenerate new weights if it gets stuck in local minima
        // -----------------------------
        
        // Train forever until the desired error threshold is met
        while true {
            // Complete one full training epoch
            for (index, input) in data.trainInputs.enumerated() {
                // Note: We don't care about outputs or error on the training set
                try infer(input)
                try backpropagate(data.trainLabels[index])
            }
            
            // Calculate the total error of the validation set after each training epoch
            var error: Float = 0
            for (index, inputs) in data.validationInputs.enumerated() {
                let outputs = try infer(inputs)
                error += cost.cost(real: outputs, expected: data.validationLabels[index])
            }
            // Divide error by number of sets to find average error across full validation set
            error /= Float(data.validationInputs.count)
            
            // Escape training loop if the network has met the error threshold
            if error < errorThreshold {
                break
            }
        }
        
        // Return the weights of the newly-trained neural network
        return allWeights()
    }
    
}
