//
//  XOR-Example.swift
//  Swift-AI
//
//  Created by Collin Hundley on 11/22/15.
//

/// A simple example of training a feed-forward neural network to function as an XOR gate.
func xorTwoWay() {
    
    print("******** Feed-Forward Neural Network: Two-Input XOR Example ********")
    
    // Initialize network
    let network = FFNN(inputs: 2, hidden: 2, outputs: 1,
        learningRate: 0.2, momentum: 0.1, weights: nil)
    
    // Create training data
    let inputs: [[Float]] = [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1]
    ]
    
    // Define answers for training data
    let answers: [[Float]] = [
        [0],
        [1],
        [0],
        [1]
    ]
    
    // Train the network
    // Note: Here we use `inputs` and `answers` as validation data as well, since there are only 4 possible inputs for XOR.
    // Generally, training data and validation data should be mutually exclusive sets but representative of the same search space.
    print("Weights before training: \(network.getWeights())")
    try! network.train(inputs: inputs, answers: answers,
        testInputs: inputs, testAnswers: answers,
        errorThreshold: 0.0001)
    print("Weights after training: \(network.getWeights())")
    
    // Print the result
    let v0 = try! network.update(inputs: inputs[0])
    let v1 = try! network.update(inputs: inputs[1])
    let v2 = try! network.update(inputs: inputs[2])
    let v3 = try! network.update(inputs: inputs[3])
    print("Target output: \(answers[0][0]), \(answers[1][0]), \(answers[2][0]), \(answers[3][0])")
    print("Actual output: \(v0[0]), \(v1[0]), \(v2[0]), \(v3[0])")
}
