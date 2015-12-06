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
    case Softmax
    /// Gaussian activation function
//    case Gaussian
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
public final class FFNN: Storage {
    
    /// The number of input nodes to the network (read only).
    let numInputs: Int
    /// The number of hidden nodes in the network (read only).
    let numHidden: Int
    /// The number of output nodes from the network (read only).
    let numOutputs: Int
    
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
    /// Stores the number of hidden weights as Int32, to avoid casting repeatedly.
    private let hiddenWeightsCount: Int32
    /// The total number of weights connecting all hidden nodes to all output nodes.
    private let numOutputWeights: Int
    /// Stores the number of output weights as Int32, to avoid casting repeatedly.
    private let outputWeightsCount: Int32
    
    /// The current weights leading into all of the hidden nodes, serialized in a single array.
    private var hiddenWeights: [Float]
    /// The weights leading into all of the hidden nodes from the previous round of training, serialized in a single array.
    /// Used for applying momentum during backpropagation.
    private var previousHiddenWeights: [Float]
    /// The current weights leading into all of the output nodes, serialized in a single array.
    private var outputWeights: [Float]
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

    
    /// Initialization with an optional array of weights.
    public init(inputs: Int, hidden: Int, outputs: Int, learningRate: Float, momentum: Float, weights: [Float]?, activationFunction : ActivationFunction, errorFunction : ErrorFunction) {
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
        self.outputCache = [Float](count: outputs, repeatedValue: 0)
        
        self.outputErrorsCache = [Float](count: self.numOutputs, repeatedValue: 0)
        self.hiddenErrorSumsCache = [Float](count: self.numHiddenNodes, repeatedValue: 0)
        self.hiddenErrorsCache = [Float](count: self.numHiddenNodes, repeatedValue: 0)
        self.newOutputWeights = [Float](count: self.numOutputWeights, repeatedValue: 0)
        self.newHiddenWeights = [Float](count: self.numHiddenWeights, repeatedValue: 0)
        
        self.hiddenWeightsCount = Int32(self.numHiddenWeights)
        self.outputWeightsCount = Int32(self.numOutputWeights)
        
        self.activationFunction = activationFunction
        self.errorFunction = errorFunction
        for weightIndex in 0..<self.numOutputWeights {
            self.outputErrorIndices.append(weightIndex / self.numHiddenNodes)
            self.hiddenOutputIndices.append(weightIndex % self.numHiddenNodes)
        }
        
        for weightIndex in 0..<self.numHiddenWeights {
            self.hiddenErrorIndices.append(weightIndex / self.numInputNodes)
            self.inputIndices.append(weightIndex % self.numInputNodes)
        }
        
        self.hiddenWeights = [Float](count: self.numHiddenWeights, repeatedValue: 0)
        self.previousHiddenWeights = self.hiddenWeights
        self.outputWeights = [Float](count: outputs * self.numHiddenNodes, repeatedValue: 0)
        self.previousOutputWeights = self.outputWeights
        
        if weights != nil {
            guard weights!.count == numHiddenWeights + numOutputWeights else {
                print("FFNN initialization error: Incorrect number of weights provided. Randomized weights will be used instead.")
                self.randomizeWeights()
                return
            }
            self.hiddenWeights = Array(weights![0..<self.numHiddenWeights])
            self.outputWeights = Array(weights![self.numHiddenWeights..<weights!.count])
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
        self.inputCache[0] = 1.0
        for i in 1..<self.numInputNodes {
            self.inputCache[i] = inputs[i - 1]
        }
        
        // Calculate the weighted sums for the hidden layer
        vDSP_mmul(self.hiddenWeights, 1,
            self.inputCache, 1,
            &self.hiddenOutputCache, 1,
            vDSP_Length(self.numHidden), vDSP_Length(1), vDSP_Length(self.numInputNodes))
        
        // Apply the activation function to the hidden layer nodes
        // Note: Array elements are shifted one index to the right, in order to efficiently insert the bias node at index 0
        for (var i = self.numHidden; i > 0; --i) {
            self.hiddenOutputCache[i] = self.activation(self.hiddenOutputCache[i - 1])
        }
        self.hiddenOutputCache[0] = 1.0
        
        //  Calculate the weighted sums for the output layer
        vDSP_mmul(self.outputWeights, 1,
            self.hiddenOutputCache, 1,
            &self.outputCache, 1,
            vDSP_Length(self.numOutputs), vDSP_Length(1), vDSP_Length(self.numHiddenNodes))
        
        // Apply the activation function to the output layer nodes
        for i in 0..<self.numOutputs {
            self.outputCache[i] = self.activation(self.outputCache[i])
        }
        
        // Return the final outputs
        switch self.activationFunction {
        case .Softmax:
            return softmax(self.outputCache)
        default:
            return self.outputCache
        }
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
            self.outputErrorsCache[outputIndex] = self.activationDerivative(output) * (answer[outputIndex] - output)
        }
        
        // Calculate hidden errors
        vDSP_mmul(self.outputErrorsCache, 1,
            self.outputWeights, 1,
            &self.hiddenErrorSumsCache, 1,
            vDSP_Length(1), vDSP_Length(self.numHiddenNodes), vDSP_Length(self.numOutputs))
        for (errorIndex, error) in self.hiddenErrorSumsCache.enumerate() {
            self.hiddenErrorsCache[errorIndex] = self.activationDerivative(self.hiddenOutputCache[errorIndex]) * error
        }
        
        // Update output weights
        for weightIndex in 0..<self.outputWeights.count {
            let offset = self.outputWeights[weightIndex] + (self.momentumFactor * (self.outputWeights[weightIndex] - self.previousOutputWeights[weightIndex]))
            let errorIndex = self.outputErrorIndices[weightIndex]
            let hiddenOutputIndex = self.hiddenOutputIndices[weightIndex]
            let mfLRErrIn = self.mfLR * self.outputErrorsCache[errorIndex] * self.hiddenOutputCache[hiddenOutputIndex]
            self.newOutputWeights[weightIndex] = offset + mfLRErrIn
        }
        cblas_scopy(self.outputWeightsCount, self.outputWeights, 1, &self.previousOutputWeights, 1)
        cblas_scopy(self.outputWeightsCount, self.newOutputWeights, 1, &self.outputWeights, 1)
        
        // Update hidden weights
        for weightIndex in 0..<self.hiddenWeights.count {
            let offset = self.hiddenWeights[weightIndex] + (self.momentumFactor * (self.hiddenWeights[weightIndex]  - self.previousHiddenWeights[weightIndex]))
            let errorIndex = self.hiddenErrorIndices[weightIndex]
            let inputIndex = self.inputIndices[weightIndex]
            // Note: +1 on errorIndex to offset for bias 'error', which is ignored
            let mfLRErrIn = self.mfLR * self.hiddenErrorsCache[errorIndex + 1] * self.inputCache[inputIndex]
            self.newHiddenWeights[weightIndex] = offset + mfLRErrIn
        }
        cblas_scopy(self.hiddenWeightsCount, self.hiddenWeights, 1, &self.previousHiddenWeights, 1)
        cblas_scopy(self.hiddenWeightsCount, self.newHiddenWeights, 1, &self.hiddenWeights, 1)

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
        return self.hiddenWeights + self.outputWeights
    }
    
    /// Returns a serialized array of the network's current weights.
    public func getWeights() -> [Float] {
        return self.hiddenWeights + self.outputWeights
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
        
        self.hiddenWeights = Array(weights[0..<self.hiddenWeights.count])
        self.outputWeights = Array(weights[self.hiddenWeights.count..<weights.count])
    }

    
    // MARK:- Storage protocol
    
    /// Reads a FFNN from file.
    /// - Parameter filename: The name of the file, located in the default Documents directory.
    public static func fromFile(filename: String) -> FFNN? {
        return self.read(self.getFileURL(filename))
    }
    
    /// Reads a FFNN from file.
    /// - Parameter url: The `NSURL` for the file to read.
    public static func fromFile(url: NSURL) -> FFNN? {
        return self.read(url)
    }

    /// Writes the FFNN to file.
    /// - Parameter filename: The name of the file to write to. This file will be written to the default Documents directory.
    public func writeToFile(filename: String) {
        self.write(FFNN.getFileURL(filename))
    }
    
    /// Writes the FFNN to file.
    /// - Parameter url: The `NSURL` to write the file to.
    public func writeToFile(url: NSURL) {
        self.write(url)
    }
    
}


// MARK:- FFNN private methods
private extension FFNN {
    
    /// Returns an NSURL for a document with the given filename in the default documents directory.
    private static func getFileURL(filename: String) -> NSURL {
        let manager = NSFileManager.defaultManager()
        let dirURL = try! manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        return dirURL.URLByAppendingPathComponent(filename)
    }
    
    /// Reads a FFNN stored in a file at the given URL.
    private static func read(url: NSURL) -> FFNN? {
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
    private func write(url: NSURL) {
        var storage = [String : AnyObject]()
        storage["inputs"] = self.numInputs
        storage["hidden"] = self.numHidden
        storage["outputs"] = self.numOutputs
        storage["learningRate"] = self.learningRate
        storage["momentum"] = self.momentumFactor
        storage["hiddenWeights"] = self.hiddenWeights
        storage["outputWeights"] = self.outputWeights
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
                    errorSum += abs(self.activationDerivative(output) * (expected[inputIndex][outputIndex] - output))
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
    
    /// Applies the activation function to the input.
    private func activation(input: Float) -> Float {
        switch self.activationFunction {
        case .None:
            return 0.0
        case .Default:
            return sigmoid(input)
        case .Linear:
            return linear(input)
        case .Sigmoid:
            return sigmoid(input)
        case .Softmax:
            return sigmoid(input)
//        case .Gaussian:
//            return gaussian(input)
        case .RationalSigmoid:
            return rationalSigmoid(input)
        case .HyperbolicTangent:
            return hyperbolicTangent(input)
        }
    }
    
    /// Calculates the derivative of the activation function, from the given `y` value.
    private func activationDerivative(output: Float) -> Float {
        switch self.activationFunction {
        case .None:
            return 0.0
        case .Default:
            return sigmoidDerivative(output)
        case .Linear:
            return linearDerivative(output)
        case .Sigmoid:
            return sigmoidDerivative(output)
        case .Softmax:
            return sigmoidDerivative(output)
//        case .Gaussian:
//            return gaussianDerivative(output)
        case .RationalSigmoid:
            return rationalSigmoidDerivative(output)
        case .HyperbolicTangent:
            return hyperbolicTangentDerivative(output)
        }
    }
    
    /// Randomizes all of the network's weights, from each layer.
    private func randomizeWeights() {
        for i in 0..<self.numHiddenWeights {
            self.hiddenWeights[i] = randomWeight(numInputNodes: self.numInputNodes)
        }
        for i in 0..<self.numOutputWeights {
            self.outputWeights[i] = randomWeight(numInputNodes: self.numHiddenNodes)
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

// MARK: Softmax Function

private func softmax(outputs: [Float]) -> [Float] {
    // exp(n)/sum(exp(n))
    var sum: Float = 0
    for output in outputs {
        sum += exp(output)
    }
    var softmaxOutputs = [Float]()
    for output in outputs {
        softmaxOutputs.append(exp(output) / sum)
    }
    return softmaxOutputs
}

// MARK: Error Functions

private func crossEntropy(a: Float, b: Float) -> Float {
    return log(a) * b
}

// MARK: Activation Functions and Derivatives

/// Linear activation function (raw sum)
private func linear(x: Float) -> Float {
    return x
}

/// Derivative for the linear activation function
private func linearDerivative(y: Float) -> Float {
    return 1.0
}

/// Sigmoid activation function
private func sigmoid(x: Float) -> Float {
    return 1 / (1 + exp(-x))
}
/// Derivative for the sigmoid activation function
private func sigmoidDerivative(y: Float) -> Float {
    return y * (1 - y)
}

/// Gaussian activation function
//private func gaussian(x: Float) -> Float {
//    return exp(-(x * x))
//}

// TODO: Derive the correct formula for this derivative with respect to `x`, from the input `y`
// x = +/- sqrt(log(1 / y))  - impossible to determine x?
/// Derivative for the Gaussian activation function
//private func gaussianDerivative(y: Float) -> Float {
//    let x = sqrt(log(1 / y)) // This is only correct for x >= 0
//    return -2 * x * y
//}

/// Rational sigmoid activation function
private func rationalSigmoid(x: Float) -> Float {
    return x / (1.0 + sqrt(1.0 + x * x))
}

/// Derivative for the rational sigmoid activation function
private func rationalSigmoidDerivative(y: Float) -> Float {
    let x = -(2 * y) / (y * y - 1)
    return 1 / ((x * x) + sqrt((x * x) + 1) + 1)
}

/// Hyperbolic tangent activation function
private func hyperbolicTangent(x: Float) -> Float {
    return tanh(x)
}

/// Derivative for the hyperbolic tangent activation function
private func hyperbolicTangentDerivative(y: Float) -> Float {
    return 1 - (y * y)
}

