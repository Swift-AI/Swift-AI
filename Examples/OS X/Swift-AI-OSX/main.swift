//
//  main.swift
//  Swift-AI
//  Created by Collin Hundley on 11/19/15.
//

// This project contains examples for using Swift AI.
// To run an example, simply un-comment the line calling the desired function.
// Note: This project should always be run in 'Release' mode, or training will take a very long time.


/// Classic XOR Example - trains a FFNN to function as a two-input XOR logic gate.
//xorTwoWay()

/// Sine Wave Example - trains a FFNN to model the function [sin(10x)/2 + 1/2] in the domain [-0.5 , 0.5]
/// The lower the error threshold, the more accurate the waveform!
/// Caution: Lower error thresholds improve accuracy, but can take exponentially longer to train.
sineWave(errorThreshold: 2.0)

/// Trains a neural network to recognize handwritten digits, using the MNIST dataset.
/// Outputs a file called 'handwriting-ffnn' to your Documents directory.
/// Import 'handwriting-ffnn' into the Swift AI iOS app to test the training!
//handwriting()
