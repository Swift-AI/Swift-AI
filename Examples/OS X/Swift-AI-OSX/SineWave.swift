//
//  SineWave.swift
//  Swift-AI
//
//  Created by Collin Hundley on 11/22/15.
//

import Foundation

func sineWave(errorThreshold: Float) {
    
    print("******** Feed-Forward Neural Network: Sine Wave Example ********")

    // Initialize network
    let network = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.7, momentum: 0.2, weights: nil, activationFunction: .Sigmoid, errorFunction: .default(average: false))
        
    // Create training data
    // Note: Each input 'set' is an array with a single x-coordinate
    var inputs = [[Float]]()
    var answers = [[Float]]()
    for i in -500...500 {
        let x = Float(i) / 1000
        inputs.append([x])
        answers.append([sineFunc(x: x)])
    }
    
    // Create a validation set
    // Note: These points lie within the same range as the training set, but very few of the points belong to both sets.
    //       These are characteristics of a good validation set.
    var testInputs = [[Float]]()
    var testAnswers = [[Float]]()
    for j in -300...300 {
        let x = Float(j) / 600
        testInputs.append([x])
        testAnswers.append([sineFunc(x: x)])
    }
    
    // Train the network
    print("Training... (may take several seconds, depending on error threshold)")
    let weights = try! network.train(inputs: inputs, answers: answers,
        testInputs: testInputs, testAnswers: testAnswers,
        errorThreshold: errorThreshold)
    
    // Print the y-coordinates for the resulting waveform
    print("TRAINING COMPLETED")
    print("Paste the following weights into Swift-AI-Playground to view your waveform:")
    print(weights)
    
}

/// sin(10x)/2 + 1/2
private func sineFunc(x: Float) -> Float {
    return (0.5 * sin(10 * x)) + 0.5
}
