//
//  Dataset.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/4/17.
//
//

import Foundation


public extension NeuralNet {
    
    /// A complete dataset for training a neural network, including training sets and validation sets.
    public struct Dataset {
        
        public enum Error: Swift.Error {
            case data(String)
        }
        
        // Training
        /// The full set of inputs for the training set.
        public let trainInputs: [[Float]]
        /// The full set of labels for the training set.
        public let trainLabels: [[Float]]
        
        // Validation
        /// The full set of inputs for the validation set.
        public let validationInputs: [[Float]]
        /// The full set of labels for the validation set.
        public let validationLabels: [[Float]]
        
        init(trainInputs: [[Float]], trainLabels: [[Float]],
             validationInputs: [[Float]], validationLabels: [[Float]],
            structure: NeuralNet.Structure) throws {
            // Ensure that an equal number of sets were provided for inputs and their corresponding answers
            guard trainInputs.count == trainLabels.count && validationInputs.count == validationLabels.count else {
                throw Error.data("The number of input sets provided for training/validation must equal the number of answer sets provided.")
            }
            // Ensure that each training input set contains the correct number of inputs
            guard trainInputs.reduce(0, {$0 + $1.count}) == structure.inputs * trainInputs.count else {
                throw Error.data("The number of inputs for each training set must equal the network's number of inputs. One or more set contains an incorrect number of inputs.")
            }
            // Ensure that each training answer set contains the correct number of outputs
            guard trainLabels.reduce(0, {$0 + $1.count}) == structure.outputs * trainLabels.count else {
                throw Error.data("The number of outputs for each training answer set must equal the network's number of outputs. One or more set contains an incorrect number of outputs.")
            }
            // Ensure that each validation input set contains the correct number of inputs
            guard validationInputs.reduce(0, {$0 + $1.count}) == structure.inputs * validationInputs.count else {
                throw Error.data("The number of inputs for each validation set must equal the network's number of inputs. One or more set contains an incorrect number of inputs.")
            }
            // Ensure that each validation answer set contains the correct number of outputs
            guard validationLabels.reduce(0, {$0 + $1.count}) == structure.outputs * validationLabels.count else {
                throw Error.data("The number of outputs for each validation answer set must equal the network's number of outputs. One or more set contains an incorrect number of outputs.")
            }
            
            // Initialize properties
            self.trainInputs = trainInputs
            self.trainLabels = trainLabels
            self.validationInputs = validationInputs
            self.validationLabels = validationLabels
        }
        
    }
    
}
