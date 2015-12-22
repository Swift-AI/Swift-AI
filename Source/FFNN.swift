//
//  FFNN.swift
//  Swift-AI
//
//  Created by Collin Hundley on 11/14/15.
//

import Accelerate
import Foundation


/// An enum containing all errors that may be thrown by FFNN.
public enum FFNNError: ErrorType {
    case InvalidInputsError(String)
    case InvalidAnswerError(String)
    case InvalidWeightsError(String)
}



/// An enum containing all supported activation functions.
public enum ActivationFunction: String {
    /// No activation function (returns zero)
    case None
    /// Default activation function (sigmoid)
    case Default
    /// Linear activation function (raw sum)
    case Linear
    /// Sigmoid activation function
    case Sigmoid
    /// Softmax output function (Sigmoid hidden activation)
    /// WARNING: Not yet fully implemented.
    case Softmax
    /// Rational sigmoid activation function
    case RationalSigmoid
    /// Hyperbolic tangent activation function
    case HyperbolicTangent
}


/// An enum containing all supported error functions.
public enum ErrorFunction {
    /// Default error function (sum)
    case Default(average: Bool)
    /// Cross Entropy function (Cross Entropy)
    case CrossEntropy(average: Bool)
}


/// A 3-Layer Feed-Forward Artificial Neural Network
public final class FFNN {
    
    /// The number of input nodes to the network (read only).
    let numInputs: Int
    /// The number of hidden nodes in the network (read only).
    let numHidden: Int
    /// The number of output nodes from the network (read only).
    let numOutputs: Int
    
    private let actFunction: ActFunction
    private var hiddenLayer: Layer
    private var outputLayer: Layer
    
    /// The 'learning rate' parameter to apply during backpropagation.
    /// This parameter may be safely tuned at any time, except for during a backpropagation cycle.
    var learningRate: Float {
        didSet(newRate) {
            self.mfLR = (1 - self.momentumFactor) * newRate
        }
    }
    
    /// The 'momentum factor' to apply during backpropagation.
    /// This parameter may be safely tuned at any time, except for during a backpropagation cycle.
    var momentumFactor: Float {
        didSet(newMomentum) {
            self.mfLR = (1 - newMomentum) * self.learningRate
        }
    }
    
    /// The activation function to use during update cycles.
    private var activationFunction : ActivationFunction = .Sigmoid
    
    /// The error function used for training
    private var errorFunction : ErrorFunction = .Default(average: false)
    /**
     The following private properties are allocated once during initializtion, in order to prevent frequent
     memory allocations for temporary variables during the update and backpropagation cycles.
     Some known properties are computed in advance in order to to avoid casting, integer division
     and modulus operations inside loops.
    */
    
    /// (1 - momentumFactor) * learningRate.
    /// Used frequently during backpropagation.
    private var mfLR: Float
    
    /// The number of input nodes, INCLUDING the bias node.
    private let numInputNodes: Int
    /// The number of hidden nodes, INCLUDING the bias node.
    private let numHiddenNodes: Int
    /// The total number of weights connecting all input nodes to all hidden nodes.
    private let numHiddenWeights: Int
    /// The total number of weights connecting all hidden nodes to all output nodes.
    private let numOutputWeights: Int
    

    /// The weights leading into all of the hidden nodes from the previous round of training, serialized in a single array.
    /// Used for applying momentum during backpropagation.
    private var previousHiddenWeights: [Float]

    /// The weights leading into all of the output nodes from the previous round of training, serialized in a single array.
    /// Used for applying momentum during backpropagation.
    private var previousOutputWeights: [Float]
    
    /// The most recent set of inputs applied to the network.
    private var inputCache: [Float]
    /// The most recent outputs from each of the hidden nodes.
    private var hiddenOutputCache: [Float]
    /// The most recent output from the network.
    private var outputCache: [Float]
    
    /// Temporary storage while calculating hidden errors, for use during backpropagation.
    private var hiddenErrorSumsCache: [Float]
    /// Temporary storage while calculating hidden errors, for use during backpropagation.
    private var hiddenErrorsCache: [Float]
    /// Temporary storage while calculating output errors, for use during backpropagation.
    private var outputErrorsCache: [Float]
    /// Temporary storage while updating hidden weights, for use during backpropagation.
    private var newHiddenWeights: [Float]
    /// Temporary storage while updating output weights, for use during backpropagation.
    private var newOutputWeights: [Float]
    
    /// The output error indices corresponding to each output weight.
    private var outputErrorIndices = [Int]()
    /// The hidden output indices corresponding to each output weight.
    private var hiddenOutputIndices = [Int]()
    /// The hidden error indices corresponding to each hidden weight.
    private var hiddenErrorIndices = [Int]()
    /// The input indices corresponding to each hidden weight.
    private var inputIndices = [Int]()

    
    /// Initializes a feed-forward neural network.
    public init(inputs: Int, hidden: Int, outputs: Int, learningRate: Float = 0.7, momentum: Float = 0.4, weights: [Float]? = nil, activationFunction: ActivationFunction = .Default, errorFunction: ErrorFunction = .Default(average: false)) {
        if inputs < 1 || hidden < 1 || outputs < 1 || learningRate <= 0 {
            print("Warning: Invalid arguments passed to FFNN initializer. Inputs, hidden, outputs and learningRate must all be positive and nonzero. Network will not perform correctly.")
        }
        
        self.numHiddenWeights = (hidden * (inputs + 1))
        self.numOutputWeights = (outputs * (hidden + 1))
        
        self.numInputs = inputs
        self.numHidden = hidden
        self.numOutputs = outputs
        
        self.numInputNodes = inputs + 1
        self.numHiddenNodes = hidden + 1
        
        self.learningRate = learningRate
        self.momentumFactor = momentum
        self.mfLR = (1 - momentum) * learningRate
        
        self.inputCache = [Float](count: self.numInputNodes, repeatedValue: 0)
        self.hiddenOutputCache = [Float](count: self.numHiddenNodes, repeatedValue: 0)
        hiddenOutputCache[0] = 1.0  // Bias should never change!!!
        
        self.outputCache = [Float](count: outputs, repeatedValue: 0)
        
        self.outputErrorsCache = [Float](count: self.numOutputs, repeatedValue: 0)
        self.hiddenErrorSumsCache = [Float](count: self.numHiddenNodes, repeatedValue: 0)
        self.hiddenErrorsCache = [Float](count: self.numHiddenNodes, repeatedValue: 0)
        self.newOutputWeights = [Float](count: self.numOutputWeights, repeatedValue: 0)
        self.newHiddenWeights = [Float](count: self.numHiddenWeights, repeatedValue: 0)
        
        self.activationFunction = activationFunction
        switch self.activationFunction {
        case .None:
            self.actFunction = NoneFunction()
        case .Default:
            self.actFunction = Sigmoid()
        case .Linear:
            self.actFunction = Linear()
        case .Sigmoid:
            self.actFunction = Sigmoid()
        case .Softmax:
            self.actFunction = Softmax()
        case .RationalSigmoid:
            self.actFunction = RationalSigmoid()
        case .HyperbolicTangent:
            self.actFunction = HyperbolicTangent()
        }
        
        self.errorFunction = errorFunction
        for weightIndex in 0..<self.numOutputWeights {
            self.outputErrorIndices.append(weightIndex / self.numHiddenNodes)
            self.hiddenOutputIndices.append(weightIndex % self.numHiddenNodes)
        }
        
        for weightIndex in 0..<self.numHiddenWeights {
            self.hiddenErrorIndices.append(weightIndex / self.numInputNodes)
            self.inputIndices.append(weightIndex % self.numInputNodes)
        }
        
        self.previousHiddenWeights = [Float](count: self.numHiddenWeights, repeatedValue: 0)
        self.previousOutputWeights = [Float](count: outputs * self.numHiddenNodes, repeatedValue: 0)
        
        self.hiddenLayer = Layer(inputs: inputs, outputs: hidden, activation: self.activationFunction)
        self.outputLayer = Layer(inputs: hidden, outputs: outputs, activation: self.activationFunction)
        
        if let weights = weights {
            guard weights.count == numHiddenWeights + numOutputWeights else {
                print("FFNN initialization error: Incorrect number of weights provided. Randomized weights will be used instead.")
                self.randomizeWeights()
                return
            }
            hiddenLayer.matrix = Array(weights[0..<self.numHiddenWeights])
            outputLayer.matrix = Array(weights[self.numHiddenWeights..<weights.count])
        } else {
            self.randomizeWeights()
        }
    }
    
    /// Propagates the given inputs through the neural network, returning the network's output.
    /// - Parameter inputs: An array of `Float`s, each element corresponding to one input node.
    /// - Returns: The network's output after applying the given inputs, as an array of `Float`s.
    public func update(inputs inputs: [Float]) throws -> [Float] {
        // Ensure that the correct number of inputs is given
        guard inputs.count == self.numInputs else {
            throw FFNNError.InvalidAnswerError("Invalid number of inputs given: \(inputs.count). Expected: \(self.numInputs)")
        }

        // Cache the inputs
        // Note: A bias node is inserted at index 0, followed by each of the given inputs
        //TODO: inputCache could be removed once backpropagation gets updated in order to not need it and use only inputs vector
        self.inputCache[0] = 1.0
        for i in 1..<self.numInputNodes {
            self.inputCache[i] = inputs[i - 1]
        }
        
        // Forward the hidden layer
        // The ouput goes into hiddenOutputCache array from secon element.
        // hiddenOutputCache's first element will always be 1.0 for bias
        // inputs has no bias in it, so we call the layer function that will copy it into a biased vector
        
        hiddenLayer.forward(inputs, output: &hiddenOutputCache + 1)

        //  Calculate the output layer
        //  We have the inputs already biased, the layer function will not copy its input
        //  We also do not have to put the output into a biased vector since this is our final output
        
        outputLayer.forward(biasedInput: hiddenOutputCache, output: &outputCache)
        
        
        
        // Return the final outputs
        return self.outputCache
    }
    
    /// Trains the network by comparing its most recent output to the given 'answers', adjusting the network's weights as needed.
    /// - Parameter answer: The 'correct' desired output for the most recent update to the network, as an array of `Float`s.
    /// - Returns: The total calculated error from the most recent update.
    public func backpropagate(answer answer: [Float]) throws -> Float {
        // Verify valid answer
        guard answer.count == self.numOutputs else {
            throw FFNNError.InvalidAnswerError("Invalid number of outputs given in answer: \(answer.count). Expected: \(self.numOutputs)")
        }
        
        // Calculate output errors
        for (outputIndex, output) in self.outputCache.enumerate() {
            switch self.activationFunction {
            case .Softmax:
                // FIXME: This isn't working correctly
                self.outputErrorsCache[outputIndex] = output - answer[outputIndex]
            default:
                self.outputErrorsCache[outputIndex] = actFunction.derivative(output) * (answer[outputIndex] - output)
            }
        }
        
        // Calculate hidden errors
        vDSP_mmul(self.outputErrorsCache, 1,
            outputLayer.matrix, 1,
            &self.hiddenErrorSumsCache, 1,
            vDSP_Length(1), vDSP_Length(self.numHiddenNodes), vDSP_Length(self.numOutputs))
        for (errorIndex, error) in self.hiddenErrorSumsCache.enumerate() {
            self.hiddenErrorsCache[errorIndex] = actFunction.derivative(self.hiddenOutputCache[errorIndex]) * error
        }
        
        // Update output weights
        for weightIndex in 0..<outputLayer.matrix.count {
            let offset = outputLayer.matrix[weightIndex] + (self.momentumFactor * (outputLayer.matrix[weightIndex] - self.previousOutputWeights[weightIndex]))
            let errorIndex = self.outputErrorIndices[weightIndex]
            let hiddenOutputIndex = self.hiddenOutputIndices[weightIndex]
            let mfLRErrIn = self.mfLR * self.outputErrorsCache[errorIndex] * self.hiddenOutputCache[hiddenOutputIndex]
            self.newOutputWeights[weightIndex] = offset + mfLRErrIn
        }
        
        vDSP_mmov(outputLayer.matrix, &previousOutputWeights, 1, vDSP_Length(numOutputWeights), 1, 1)
        vDSP_mmov(newOutputWeights, &outputLayer.matrix, 1, vDSP_Length(numOutputWeights), 1, 1)
    
        
        // Update hidden weights
        for weightIndex in 0..<hiddenLayer.matrix.count {
            let offset = hiddenLayer.matrix[weightIndex] + (self.momentumFactor * (hiddenLayer.matrix[weightIndex]  - self.previousHiddenWeights[weightIndex]))
            let errorIndex = self.hiddenErrorIndices[weightIndex]
            let inputIndex = self.inputIndices[weightIndex]
            // Note: +1 on errorIndex to offset for bias 'error', which is ignored
            let mfLRErrIn = self.mfLR * self.hiddenErrorsCache[errorIndex + 1] * self.inputCache[inputIndex]
            self.newHiddenWeights[weightIndex] = offset + mfLRErrIn
        }
        
        vDSP_mmov(hiddenLayer.matrix, &previousHiddenWeights, 1, vDSP_Length(numHiddenWeights), 1, 1)
        vDSP_mmov(newHiddenWeights, &hiddenLayer.matrix, 1, vDSP_Length(numHiddenWeights), 1, 1)
        
        // Sum and return the output errors
        return self.outputErrorsCache.reduce(0, combine: { (sum, error) -> Float in
            return sum + abs(error)
        })
    }
    
    /// Trains the network using the given set of inputs and corresponding outputs.
    /// - Parameters: 
    ///     - inputs: A 2D array of `Float`s.
    ///             Inner array: A single set of inputs for the network. Outer array: The full set of training data to be used for training.
    ///     - answers: A 2D array of `Float`s.
    ///             Inner array: A single set of outputs expected from the network. Outer array: The full set of output data to be used for training.
    ///     - testInputs: A set of validation data to be used for testing the network.
    ///             This data will not used in the network's training, but will be used to determine when an acceptable solution has been found.
    ///     - testAnswers: The set of expected outputs corresponding to `testInputs`.
    ///     - errorThreshold: A `Float` indicating the maximum error allowed per epoch of validation data, before the network is considered 'trained'.
    ///             This value must be determined by the user, because it varies based on the type of data used and the desired accuracy.
    /// - Returns: The final calculated weights of the network after training has completed.
    public func train(inputs inputs: [[Float]], answers: [[Float]], testInputs: [[Float]], testAnswers: [[Float]], errorThreshold: Float) throws -> [Float] {
        guard errorThreshold > 0 else {
            throw FFNNError.InvalidInputsError("Error threshold must be greater than zero!")
        }
        
        // TODO: Allow trainer to exit early or regenerate new weights if it gets stuck in local minima
        
        // Train forever until the desired error threshold is met
        while true {
            for (index, input) in inputs.enumerate() {
                try self.update(inputs: input)
                try self.backpropagate(answer: answers[index])
            }
            // Calculate the total error of the validation set after each epoch
            let errorSum: Float = try self.error(testInputs, expected: testAnswers)
            if errorSum < errorThreshold {
                break
            }
        }
        return hiddenLayer.matrix + outputLayer.matrix
    }
    
    /// Returns a serialized array of the network's current weights.
    public func getWeights() -> [Float] {
        return hiddenLayer.matrix + outputLayer.matrix
    }
    
    /// Resets the network with the given weights (i.e. from a pre-trained network).
    /// This change may be performed at any time except while the network is in the process of updating or backpropagating.
    /// - Parameter weights: An array of `Float`s, to be used as the weights for the network.
    /// - Important: The number of weights must equal numHidden * (numInputs + 1) + numOutputs * (numHidden + 1),
    /// or the weights will be rejected.
    public func resetWithWeights(weights: [Float]) throws {
        guard weights.count == self.numHiddenWeights + self.numOutputWeights else {
            throw FFNNError.InvalidWeightsError("Invalid number of weights provided: \(weights.count). Expected: \(self.numHiddenWeights + self.numOutputWeights)")
        }
        
        hiddenLayer.matrix = Array(weights[0..<hiddenLayer.matrix.count])
        outputLayer.matrix = Array(weights[hiddenLayer.matrix.count..<weights.count])
    }
}

// MARK:- FFNN private methods

public extension FFNN {
    
    /// Returns an NSURL for a document with the given filename in the default documents directory.
    public static func getFileURL(filename: String) -> NSURL {
        let manager = NSFileManager.defaultManager()
        let dirURL = try! manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        return dirURL.URLByAppendingPathComponent(filename)
    }
    
    /// Reads a FFNN stored in a file at the given URL.
    public static func read(url: NSURL) -> FFNN? {
        guard let data = NSData(contentsOfURL: url) else {
            return nil
        }
        guard let storage = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String : AnyObject] else {
            return nil
        }
        
        // Read dictionary from file
        guard let numInputs = storage["inputs"] as? Int,
            let numHidden = storage["hidden"] as? Int,
            let numOutputs = storage["outputs"] as? Int,
            let momentumFactor = storage["momentum"] as? Float,
            let learningRate = storage["learningRate"] as? Float,
            let activationFunction = storage["activationFunction"] as? String,
            let hiddenWeights = storage["hiddenWeights"] as? [Float],
            let outputWeights = storage["outputWeights"] as? [Float] else {
                return nil
        }
        
        // Fallback to Default activation if an unknown value is found (i.e. newer version of FFNN)
        var activation = ActivationFunction(rawValue: activationFunction)
        if activation == nil {
            print("Warning: Unknown activation function read from file. Using Default activation instead.")
            activation = ActivationFunction.Default
        }
        
        let weights = hiddenWeights + outputWeights
        
        let n = FFNN(inputs: numInputs, hidden: numHidden, outputs: numOutputs, learningRate: learningRate, momentum: momentumFactor, weights: weights, activationFunction: activation!, errorFunction: .Default(average: false))
        return n
    }
    
    /// Writes the current state of the FFNN to a file at the given URL.
    public func write(url: NSURL) {
        var storage = [String : AnyObject]()
        storage["inputs"] = self.numInputs
        storage["hidden"] = self.numHidden
        storage["outputs"] = self.numOutputs
        storage["learningRate"] = self.learningRate
        storage["momentum"] = self.momentumFactor
        storage["hiddenWeights"] = hiddenLayer.matrix
        storage["outputWeights"] = outputLayer.matrix
        storage["activationFunction"] = self.activationFunction.rawValue
        
        let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(storage)
        data.writeToURL(url, atomically: true)
    }
    
    /// Computes the error over the given training set.
    private func error(result: [[Float]], expected: [[Float]]) throws -> Float {
        var errorSum: Float = 0
        switch self.errorFunction {
        case .Default(let average):
            for (inputIndex, input) in result.enumerate() {
                let outputs = try self.update(inputs: input)
                for (outputIndex, output) in outputs.enumerate() {
                    errorSum += abs(actFunction.derivative(output) * (expected[inputIndex][outputIndex] - output))
                }
            }
            if average {
                errorSum /= Float(result.count)
            }
        case .CrossEntropy(let average):
            for (inputIndex, input) in result.enumerate() {
                let outputs = try self.update(inputs: input)
                for (outputIndex, output) in outputs.enumerate() {
                    errorSum += crossEntropy(output, b: expected[inputIndex][outputIndex])
                }
            }
            errorSum = -errorSum
            if average {
                errorSum /= Float(result.count)
            }
        }
        return errorSum
    }

    
    /// Randomizes all of the network's weights, from each layer.
    private func randomizeWeights() {
        for i in 0..<self.numHiddenWeights {
            hiddenLayer.matrix[i] = randomWeight(numInputNodes: self.numInputNodes)
        }
        for i in 0..<self.numOutputWeights {
            outputLayer.matrix[i] = randomWeight(numInputNodes: self.numHiddenNodes)
        }
    }

}

// TODO: Generate random weights along a normal distribution, rather than a uniform distribution.
// Also, these weights are only optimal for sigmoid activation. They don't work well with other functions

/// Generates a random weight for a layer node, based on the parameters set for the network.
/// Will return a Float between +/- 1/sqrt(numInputNodes).
private func randomWeight(numInputNodes numInputNodes: Int) -> Float {
    let range = 1 / sqrt(Float(numInputNodes))
    let rangeInt = UInt32(2_000_000 * range)
    let randomFloat = Float(arc4random_uniform(rangeInt)) - Float(rangeInt / 2)
    return randomFloat / 1_000_000
}

// MARK: Error Functions

@inline(__always) private func crossEntropy(a: Float, b: Float) -> Float {
    return log(a) * b
}


// MARK: - Activation Functions and Derivatives

private protocol ActFunction {
    /// Calculate the activation for a single node having value x
    func activate(x: Float) -> Float
    
    /// Calculates the derivative of the activation function, from the given `y` value.
    func derivative(y: Float) -> Float
}

extension ActFunction {
    // Default protocol implementation for nodes activations
    @inline(__always) private func activateNodes(nodes: UnsafeMutablePointer<Float>, nodesCount: Int) {
        var currentNode = nodes
        for _ in 0..<nodesCount {
            currentNode.memory = activate(currentNode.memory)
            currentNode = currentNode.successor()
        }
    }
}

private struct NoneFunction: ActFunction {
    /// None activation function
    @inline(__always) private func activate(x: Float) -> Float {
        return 0.0
    }
    
    /// Derivative for the none activation function
    @inline(__always) private func derivative(y: Float) -> Float {
        return 0.0
    }
}


private struct Linear: ActFunction {
    /// Linear activation function (raw sum)
    @inline(__always) private func activate(x: Float) -> Float {
        return x
    }
    
    /// Derivative for the linear activation function
    @inline(__always) private func derivative(y: Float) -> Float {
        return 1.0
    }
}


private struct Sigmoid: ActFunction {
    /// Sigmoid activation function
    @inline(__always) func activate(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    
    /// Derivative for the sigmoid activation function
    @inline(__always) private func derivative(y: Float) -> Float {
        return y * (1 - y)
    }
}


private struct Softmax: ActFunction {
    /// Softmax activation function
    @inline(__always) private func activate(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    
    /// Derivative for the softmax activation function
    @inline(__always) private func derivative(y: Float) -> Float {
        return y * (1 - y)
    }
}


private struct RationalSigmoid: ActFunction {
    
    /// Rational sigmoid activation function
    @inline(__always) private func activate(x: Float) -> Float {
        return x / (1.0 + sqrt(1.0 + x * x))
    }
    
    /// Derivative for the rational sigmoid activation function
    @inline(__always) private func derivative(y: Float) -> Float {
        let x = -(2 * y) / (y * y - 1)
        return 1 / ((x * x) + sqrt((x * x) + 1) + 1)
    }
}


private struct HyperbolicTangent: ActFunction {
    /// Hyperbolic tangent activation function
    @inline(__always) private func activate(x: Float) -> Float {
        return tanh(x)
    }
    
    /// Derivative for the hyperbolic tangent activation function
    @inline(__always) private func derivative(y: Float) -> Float {
        return 1 - (y * y)
    }
}

//MARK: - Layer
private struct Layer {
    let activationFunction: ActFunction
    let biasedInputsCount: Int
    let inputsCount: Int
    let outputsCount: Int
    var biasedInput: [Float]
    var matrix: [Float]
    
    init(inputs: Int, outputs: Int, activation: ActivationFunction, weights: [Float]) {
        
        switch activation {
        case .None:
            self.activationFunction = NoneFunction()
        case .Default:
            self.activationFunction = Sigmoid()
        case .Linear:
            self.activationFunction = Linear()
        case .Sigmoid:
            self.activationFunction = Sigmoid()
        case .Softmax:
            self.activationFunction = Softmax()
        case .RationalSigmoid:
            self.activationFunction = RationalSigmoid()
        case .HyperbolicTangent:
            self.activationFunction = HyperbolicTangent()
        }
        
        self.biasedInputsCount = inputs + 1
        self.inputsCount = inputs
        self.outputsCount = outputs
        self.biasedInput = Array<Float>(count: biasedInputsCount, repeatedValue: 1.0)   // First element will always remain 1.0 for bias
        self.matrix = weights
    }
    
    func forward(biasedInput input: UnsafePointer<Float>, output: UnsafeMutablePointer<Float>) {
        // Vectorized calculation of node values
        vDSP_mmul(matrix, 1,
            input, 1,
            output, 1,
            vDSP_Length(outputsCount), vDSP_Length(1), vDSP_Length(biasedInputsCount))
        
        // Nodes Activation
        activationFunction.activateNodes(output, nodesCount: outputsCount)
        
        //TODO: Implement Softmax_ing if layer requires it
        
        /*
        switch self.activationFunction { ...
        case .Softmax:
        var sum: Float = 0
        let max = self.outputCache.maxElement()!
        for i in 0..<self.numOutputs {
        self.outputCache[i] = self.outputCache[i] - max
        }
        for i in 0..<self.numOutputs {
        self.outputCache[i] = exp(self.outputCache[i])
        sum += self.outputCache[i]
        }
        for i in 0..<self.numOutputs {
        self.outputCache[i] = self.outputCache[i] / sum
        }
        */
    }
    
    mutating func forward(input: UnsafePointer<Float>, output: UnsafeMutablePointer<Float>) {
        // Copy input into self bised input vector
        vDSP_mmov(input, &biasedInput + 1, 1, vDSP_Length(inputsCount), 1, 1)
        
        forward(biasedInput: biasedInput, output: output)
    }
}

extension Layer {
    // Convenience initializer with all zero weights
    init(inputs: Int, outputs: Int, activation: ActivationFunction) {
        let zeroWeights = Array<Float>(count: (inputs + 1) * outputs, repeatedValue: 0.0)
        self.init(inputs: inputs, outputs: outputs, activation: activation, weights: zeroWeights)
    }
}
