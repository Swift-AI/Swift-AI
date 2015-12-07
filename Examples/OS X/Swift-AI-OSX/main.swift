//
//  main.swift
//  Swift-AI
//  Created by Collin Hundley on 11/19/15.
//

// This project contains examples for using Swift AI.
// To run an example, simply un-comment the line calling the desired function.


// MARK:- FFNN Examples

/// Classic XOR Example - trains a FFNN to function as a two-input XOR logic gate.
//xorTwoWay()

/// Sine Wave Example - trains a FFNN to model the function [sin(10x)/2 + 1/2] in the domain [-0.5 , 0.5]
/// The lower the error threshold, the more accurate the waveform!
/// Caution: Lower error thresholds improve accuracy, but can take exponentially longer to train.
//sineWave(errorThreshold: 2.0)



func softTest() {
    let network = FFNN(inputs: 10, hidden: 7, outputs: 5, learningRate: 0.6, momentum: 0.3, weights: nil, activationFunction: .Softmax, errorFunction: ErrorFunction.Default(average: false))
    
    // Create training data
    // Note: Each input 'set' is an array with a single x-coordinate
    var inputs = [[Float]]()
    var answers = [[Float]]()
    for i in 0..<10 {
        var array = [Float](count: 10, repeatedValue: 0)
        array[i] = 1
        inputs.append(array)
        var answerArray = [Float](count: 5, repeatedValue: 0)
        answerArray[i / 2] = 1
        answers.append(answerArray)
    }

    for _ in 0..<100 {
        for index in 0..<10 {
            try! network.update(inputs: inputs[index])
            try! network.backpropagate(answer: answers[index])
        }
    }

    for index in 0..<10 {
        let output = try! network.update(inputs: inputs[index])
        print("Output: \(output)")
        print("Target: \(answers[index])")
    }
    
    
}

softTest()