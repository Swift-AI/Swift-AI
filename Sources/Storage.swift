//
//  Storage.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/4/17.
//
//

import Foundation


// MARK: Utilities for persisting/retrieving a NeuralNet from disk.

public extension NeuralNet {
    
    // -------------------
    // NOTE: Our storage protocol writes data to JSON file in plaintext,
    // rather than adopting a standard storage protocol like NSCoding.
    // This will allow Swift AI components to be written/read across platforms without compatibility issues.
    // -------------------
    

    // MARK: JSON keys
    
    static let inputsKey = "inputs"
    static let hiddenKey = "hidden"
    static let outputsKey = "outputs"
    static let momentumKey = "momentum"
    static let learningKey = "learningRate"
    static let activationKey = "activationFunction"
    static let weightsKey = "weights"
    
    
    /// Attempts to initialize a NeuralNet from a file stored at the given URL.
    public convenience init(url: URL) throws {
        // Read data
        let data = try Data(contentsOf: url)
        // Extract top-level object from data
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        // Attempt to convert object into an Array
        guard let array = json as? [String : Any] else {
            throw Error.initialization("Unable to read JSON data from file.")
        }
        // Read all required values from JSON
        guard let inputs = array[NeuralNet.inputsKey] as? Int,
            let hidden = array[NeuralNet.hiddenKey] as? Int,
            let outputs = array[NeuralNet.outputsKey] as? Int,
            let momentum = array[NeuralNet.momentumKey] as? Float,
            let lr = array[NeuralNet.learningKey] as? Float,
            let activationStr = array[NeuralNet.activationKey] as? String,
            let weights = array[NeuralNet.weightsKey] as? [Float]
            else {
                throw Error.initialization("One or more required NeuralNet properties are missing.")
        }
        
        // Convert activation function to enum
        var activation: ActivationFunction
        // Check for custom activation function
        if activationStr == "custom" {
            // Note: Here we simply warn the user and set the activation to defualt (sigmoid)
            // The user should reset the activation to the original custom function manually
            print("NeuralNet warning: custom activation function detected in stored network. Defaulting to sigmoid activation. It is your responsibility to reset the network's activation to the original function, or it is unlikely to perform correctly.")
            activation = ActivationFunction.sigmoid
        } else {
            guard let function = ActivationFunction.from(activationStr) else {
                throw Error.initialization("Unrecognized activation function in file: \(activationStr)")
            }
            activation = function
        }
        
        // Recreate Structure object
        let structure = try Structure(inputs: inputs, hidden: hidden, outputs: outputs)
        
        // Recreate Config object
        let config = try Configuration(activation: activation, learningRate: lr, momentum: momentum)
        
        // Initialize neural network
        try self.init(structure: structure, config: config, weights: weights)
    }
    
    
    /// Saves the NeuralNet to a file at the given URL.
    public func save(to url: URL) throws {
        // Create top-level JSON object
        let json: [String : Any] = [
            NeuralNet.inputsKey : structure.inputs,
            NeuralNet.hiddenKey : structure.hidden,
            NeuralNet.outputsKey : structure.outputs,
            NeuralNet.momentumKey : momentumFactor,
            NeuralNet.learningKey : learningRate,
            NeuralNet.activationKey : activationFunction.stringValue(),
            NeuralNet.weightsKey : allWeights()
        ]
        
        // Serialize array into JSON data
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        
        // Write data to file
        try data.write(to: url)
    }
    
}

