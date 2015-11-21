//
//  main.swift
//  Swift-AI
//
//  Created by Collin Hundley on 11/19/15.
//

func xorTwoWay() {
	let network = FFNN(inputs: 2, hidden: 2, outputs: 1,
		learningRate: 0.1, momentum: 0.1, weights: nil)
	
	let inputs: [[Float]] = [
		[0, 0],
		[0, 1],
		[1, 0],
		[1, 1]
	]
	
	let answers: [[Float]] = [
		[0],
		[1],
		[0],
		[1]
	]
	
	print("before training: \(network.getWeights())")
	try! network.train(inputs: inputs, answers: answers, testInputs: [], testAnswers: [], errorThreshold: 0.1)
	print("after training: \(network.getWeights())")
	
	let v0 = try! network.update(inputs: inputs[0])
	let v1 = try! network.update(inputs: inputs[1])
	let v2 = try! network.update(inputs: inputs[2])
	let v3 = try! network.update(inputs: inputs[3])
	print("values: ")
	print(v0, v1, v2, v3)
}

xorTwoWay()
