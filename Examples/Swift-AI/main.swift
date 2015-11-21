//
//  main.swift
//  Swift-AI
//
//  Created by Collin Hundley on 11/19/15.
//

/// A simple example of training a feed-forward neural network to function as an XOR gate.
func xorTwoWay() {
    
    // Initialize network
	let network = FFNN(inputs: 2, hidden: 2, outputs: 1,
		learningRate: 0.1, momentum: 0.1, weights: nil)
	
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
	print("Weights before training: \(network.getWeights())")
	try! network.train(inputs: inputs, answers: answers,
        testInputs: inputs, testAnswers: answers,
        errorThreshold: 0.001)
	print("Weights after training: \(network.getWeights())")
	
    // Print the result
	let v0 = try! network.update(inputs: inputs[0])
	let v1 = try! network.update(inputs: inputs[1])
	let v2 = try! network.update(inputs: inputs[2])
	let v3 = try! network.update(inputs: inputs[3])
    print("Target output: \(answers[0][0]), \(answers[1][0]), \(answers[2][0]), \(answers[3][0])")
	print("Actual output: \(v0.first!), \(v1.first!), \(v2.first!), \(v3.first!)")
}

// Start the XOR example
xorTwoWay()
