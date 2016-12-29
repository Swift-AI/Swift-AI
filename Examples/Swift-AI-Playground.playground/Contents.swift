//
// Swift-AI-Playground
//
// This playground contains more examples for using Swift AI.

import XCPlayground
import Foundation

// NOTE: For viewing graphs, you may need to open the Assistant Editor and select Timeline ->

/// Use this function to plot a waveform with your neural network, after training it in the 'Sine Wave' example!
func plotSineWave() {
    
    // ** REPLACE THESE WITH YOUR OWN TRAINED WEIGHTS **
    let weights: [Float] = [-2.43487, -4.85964, -2.71369, 17.8095, -2.19361, -10.0174, -2.4996, -18.5615, -4.72742, -22.6862, 2.64097, -25.6419, 7.10783, -14.4343, -5.19608, -10.6748, 0.292458, 4.7248, -11.8286, -4.07718, -10.5039, 10.9235, -11.4324, 11.7543, 9.22874]

    // Initialize neural network with pre-trained weights (may need to change activation function if yours was trained with a different one)
    let network = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.7, momentum: 0.2, weights: weights, activationFunction: .Sigmoid, errorFunction: .default(average: false))
    
    // Plot points in domain [-0.5 , 0.5]
    for i in -500...500 {
        let x = Float(i) / 1000
        let output = try! network.update(inputs: [x]).first!
        XCPlaygroundPage.currentPage.captureValue(value: output, withIdentifier: "Sine Wave")
    }
}

// ** UNCOMMENT THIS LINE TO RUN **
//plotSineWave()


func sine() {
    var outputs = [Float]()
    
    let network = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.7, momentum: 0.2, weights: nil, activationFunction: .Sigmoid, errorFunction: ErrorFunction.default(average: false))
    
    for _ in 0..<4000 {
        for i in -500...500 {
            let x = Float(i) / 1000
            try! network.update(inputs: [x])
            let answer = sineFunc(x)
            try! network.backpropagate(answer: [answer])
        }
    }
    
    for i in -1000...1000 {
        let x = Float(i) / 1000
        let output = try! network.update(inputs: [x]).first!
        outputs.append(output)
    }
    
    print(outputs)
}

/// sin(10x)/2 + 1/2
private func sineFunc(_ x: Float) -> Float {
    return (0.5 * sin(10 * x)) + 0.5
}

//sine()

