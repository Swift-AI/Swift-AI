//
//  Cache.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/3/17.
//
//

import Foundation


internal extension NeuralNet {
    
    /*
     -------------------------------------------
     
     NOTE: The following cache is allocated once during NeuralNet initializtion, in order to prevent frequent
     heap allocations for temporary variables during the inference and backpropagation cycles.
     Some known properties are computed in advance in order to to avoid type casting, integer division
     and modulus operations inside loops.
     
     -------------------------------------------
     */
    
    /// A set of pre-computed values and caches used internally by `NeuralNet`.
    struct Cache {
        
        /// (1 - momentumFactor) * learningRate.
        /// Used frequently during backpropagation.
        var mfLR: Float
        
        /// The current weights leading into all of the hidden nodes, serialized in a single array.
        var hiddenWeights: [Float]
        /// The weights leading into all of the hidden nodes from the previous round of training, serialized in a single array.
        /// Used for applying momentum during backpropagation.
        var previousHiddenWeights: [Float]
        /// The current weights leading into all of the output nodes, serialized in a single array.
        var outputWeights: [Float]
        /// The weights leading into all of the output nodes from the previous round of training, serialized in a single array.
        /// Used for applying momentum during backpropagation.
        var previousOutputWeights: [Float]
        
        /// The most recent set of inputs applied to the network.
        var inputCache: [Float]
        /// The most recent outputs from each of the hidden nodes.
        var hiddenOutputCache: [Float]
        /// The most recent output from the network.
        var outputCache: [Float]
        
        /// Temporary storage while calculating hidden errors, for use during backpropagation.
        var hiddenErrorSumsCache: [Float]
        /// Temporary storage while calculating hidden errors, for use during backpropagation.
        var hiddenErrorsCache: [Float]
        /// Temporary storage while calculating output errors, for use during backpropagation.
        var outputErrorsCache: [Float]
        /// Temporary storage while updating hidden weights, for use during backpropagation.
        var newHiddenWeights: [Float]
        /// Temporary storage while updating output weights, for use during backpropagation.
        var newOutputWeights: [Float]
        
        /// The output error indices corresponding to each output weight.
        var outputErrorIndices = [Int]()
        /// The hidden output indices corresponding to each output weight.
        var hiddenOutputIndices = [Int]()
        /// The hidden error indices corresponding to each hidden weight.
        var hiddenErrorIndices = [Int]()
        /// The input indices corresponding to each hidden weight.
        var inputIndices = [Int]()
        
        init(structure: NeuralNet.Structure, config: NeuralNet.Configuration) {
            self.mfLR = (1 - config.momentumFactor)
            
            self.inputCache = [Float](repeatElement(0, count: structure.numInputNodes))
            self.hiddenOutputCache = [Float](repeatElement(0, count: structure.numHiddenNodes))
            self.outputCache = [Float](repeatElement(0, count: structure.outputs))
            
            self.outputErrorsCache = [Float](repeatElement(0, count: structure.outputs))
            self.hiddenErrorSumsCache = [Float](repeatElement(0, count: structure.numHiddenNodes))
            self.hiddenErrorsCache = [Float](repeatElement(0, count: structure.numHiddenNodes))
            self.newOutputWeights = [Float](repeatElement(0, count: structure.numOutputWeights))
            self.newHiddenWeights = [Float](repeatElement(0, count: structure.numHiddenWeights))
            
            for i in 0..<structure.numOutputWeights {
                self.outputErrorIndices.append(i / structure.numHiddenNodes)
                self.hiddenOutputIndices.append(i % structure.numHiddenNodes)
            }
            
            for i in 0..<structure.numHiddenWeights {
                self.hiddenErrorIndices.append(i / structure.numInputNodes)
                self.inputIndices.append(i % structure.numInputNodes)
            }
            
            self.hiddenWeights = [Float](repeatElement(0, count: structure.numHiddenWeights))
            self.previousHiddenWeights = self.hiddenWeights
            self.outputWeights = [Float](repeatElement(0, count: structure.outputs * structure.numHiddenNodes))
            self.previousOutputWeights = self.outputWeights
        }
        
    }
    
}

