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

var fitness : FitnessFunction

fitness =  { v in
    
    // 2 = 5 * v0  - 7 * v1
    return abs(2  - v[0]*5 + 7*v[1])
}

let m = Vector(size: 2)
m[0] = -5
m[1] = 4


let n = Vector(size: 2)
n[0] = -3
n[1] = 4

let gene = Genetic(populationSize: 1000, selectionRate: 0.25, mutationRate: 0.3, mutationSize: 2, crossRate: 0.25, function: fitness, generations: 1000, initialPopulation: [m,n])

gene.evolve()