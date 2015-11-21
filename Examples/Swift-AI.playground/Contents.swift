// Swift-AI.playground
// Created by Collin Hundley on 11/20/15.

import XCPlayground
import Foundation

func function(x: Float) -> Float {
//    return (0.5 * sin(10 * x)) + 0.5
    return 5
}

let network = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.7, momentum: 0.4, weights: nil)


func graph() {
    for j in -500...500 {
        let x = Float(j) / 1000
        let y = function(x)
        XCPlaygroundPage.currentPage.captureValue(y, withIdentifier: "Sine Wave")
    }
    
//    for _ in 0..<100 {
        for j in -500...500 {
            let x = Float(j) / 1000
            let y = function(x)
            try! network.update(inputs: [x]).first!
            try! network.backpropagate(answer: [y])
        }
//    }
    for j in -500...500 {
        
        let x = Float(j) / 1000
        let output = try! network.update(inputs: [x]).first!
        
        XCPlaygroundPage.currentPage.captureValue(output, withIdentifier: "Sine Wave")
    }
}

//graph()