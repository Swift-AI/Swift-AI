//
//  Handwriting.swift
//  Swift-AI-OSX
//
//  Created by Collin Hundley on 12/15/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import Foundation

class HandwritingTrainer {
    
    let network = FFNN(inputs: 784, hidden: 560, outputs: 10, learningRate: 1.0, momentum: 0.5, weights: nil, activationFunction: .Sigmoid, errorFunction: .crossEntropy(average: true))
    var trainImages = [[Float]]()
    var trainLabels = [UInt8]()
    var testImages = [[Float]]()
    var testLabels = [UInt8]()

    func extractTrainingData() {
        print("Extracting training data...")
        // Create variables for storing data
        var trainImages = [[Float]]()
        var trainLabels = [UInt8]()
        var testImages = [[Float]]()
        var testLabels = [UInt8]()
        // Define image size
        let numTrainImages = 60_000
        let numTestImages = 10_000
        let imageSize = CGSize(width: 28, height: 28)
        let numPixels = Int(imageSize.width * imageSize.height)
        // Extract training data
        let executablePath = Bundle.main.executablePath!
        let projectURL = NSURL(fileURLWithPath: executablePath).deletingLastPathComponent!
        let trainImagesURL = projectURL.appendingPathComponent("train-images-idx3-ubyte")
        let trainImagesData = NSData(contentsOf: trainImagesURL)!
        // Extract testing data
        let testImagesURL = projectURL.appendingPathComponent("t10k-images-idx3-ubyte")
        let testImagesData = NSData(contentsOf: testImagesURL)!
        // Extract training labels
        let trainLabelsURL = projectURL.appendingPathComponent("train-labels-idx1-ubyte")
        let trainLablelsData = NSData(contentsOf: trainLabelsURL)!
        // Extract testing labels
        let testLabelsURL = projectURL.appendingPathComponent("t10k-labels-idx1-ubyte")
        let testLablelsData = NSData(contentsOf: testLabelsURL)!
        // Store image/label byte indices
        var imagePosition = 16 // Start after header info
        var labelPosition = 8 // Start after header info
        for imageIndex in 0..<numTrainImages {
            if imageIndex % 10_000 == 0 || imageIndex == numTrainImages - 1 {
                print("\((imageIndex + 1) * 100 / numTrainImages)%")
            }
            // Extract training image pixels
            var trainPixelsArray = [UInt8](repeating: 0, count: numPixels)
            trainImagesData.getBytes(&trainPixelsArray, range: NSMakeRange(imagePosition, numPixels))
            // Convert pixels to Floats
            var trainPixelsFloatArray = [Float](repeating: 0, count: numPixels)
            for (index, pixel) in trainPixelsArray.enumerated() {
                trainPixelsFloatArray[index] = Float(pixel) / 255
            }
            // Append image to array
            trainImages.append(trainPixelsFloatArray)
            // Extract labels
            var trainLabel = [UInt8](repeating: 0, count: 1)
            trainLablelsData.getBytes(&trainLabel, range: NSMakeRange(labelPosition, 1))
            // Append label to array
            trainLabels.append(trainLabel.first!)
            // Extract test image/label if we're still in range
            if imageIndex < numTestImages {
                // Extract test image pixels
                var testPixelsArray = [UInt8](repeating: 0, count: numPixels)
                testImagesData.getBytes(&testPixelsArray, range: NSMakeRange(imagePosition, numPixels))
                // Convert pixels to Floats
                var testPixelsFloatArray = [Float](repeating: 0, count: numPixels)
                for (index, pixel) in testPixelsArray.enumerated() {
                    testPixelsFloatArray[index] = Float(pixel) / 255
                }
                // Append image to array
                testImages.append(testPixelsFloatArray)
                // Extract labels
                var testLabel = [UInt8](repeating: 0, count: 1)
                testLablelsData.getBytes(&testLabel, range: NSMakeRange(labelPosition, 1))
                // Append label to array
                testLabels.append(testLabel.first!)
            }
            // Increment counters
            imagePosition += numPixels
            labelPosition += 1
        }
        self.trainImages = trainImages
        self.trainLabels = trainLabels
        self.testImages = testImages
        self.testLabels = testLabels
    }
    
    func trainNetwork() {
        print("\nTraining neural network...")
        // Convert training labels into Float answer arrays
        var trainAnswers = [[Float]]()
        for label in self.trainLabels {
            trainAnswers.append(self.labelToArray(label: label))
        }
        var testAnswers = [[Float]]()
        for label in self.testLabels {
            testAnswers.append(self.labelToArray(label: label))
        }
        do {
            print("\nBefore training:")
            var errorSum: Float = 0
            var correct: Float = 0
            var incorrect: Float = 0
            for (index, image) in self.testImages.enumerated() {
                let outputArray = try self.network.update(inputs: image)
                if let outputLabel = self.outputToLabel(output: outputArray) {
                    if outputLabel == self.testLabels[index] {
                        correct += 1
                    } else {
                        incorrect += 1
                    }
                } else {
                    incorrect += 1
                }
                let answerArray = testAnswers[index]
                errorSum += self.calculateError(output: outputArray, answer: answerArray)
            }
            let percent = correct * 100 / (correct + incorrect)
            print("Error sum: \(errorSum)")
            print("Correct: \(Int(correct))")
            print("Incorrect: \(Int(incorrect))")
            print("Accuracy: \(percent)%")
            
            var epoch = 1
            while true {
                print("\nEpoch \(epoch): Learning rate \(self.network.learningRate)")
                for (index, image) in self.trainImages.enumerated() {
                    try self.network.update(inputs: image)
                    let answer = trainAnswers[index]
                    try self.network.backpropagate(answer: answer)
                }
                var errorSum: Float = 0
                var correct: Float = 0
                var incorrect: Float = 0
                for (index, image) in self.testImages.enumerated() {
                    let outputArray = try self.network.update(inputs: image)
                    if let outputLabel = self.outputToLabel(output: outputArray) {
                        if outputLabel == self.testLabels[index] {
                            correct += 1
                        } else {
                            incorrect += 1
                        }
                    } else {
                        incorrect += 1
                    }
                    let answerArray = testAnswers[index]
                    errorSum += self.calculateError(output: outputArray, answer: answerArray)
                }
                let percent = correct * 100 / (correct + incorrect)
                print("Error sum: \(errorSum)")
                print("Correct: \(Int(correct))")
                print("Incorrect: \(Int(incorrect))")
                print("Accuracy: \(percent)%")
                self.network.learningRate *= 0.75
                self.network.momentumFactor *= 0.75
                if percent > 98.0 || epoch == 10 {
                    self.network.writeToFile("handwriting-ffnn")
                    break
                }
                epoch += 1
            }
        } catch {
            print(error)
        }
        print("\nTraining completed! Neural network stored at ~/Documents/handwriting-ffnn")
    }
    
    private func calculateError(output: [Float], answer: [Float]) -> Float {
        var error: Float = 0
        for (index, element) in output.enumerated() {
            error += abs(element - answer[index])
        }
        return error
    }
    
    private func labelToArray(label: UInt8) -> [Float] {
        var answer = [Float](repeating: 0, count: 10)
        answer[Int(label)] = 1
        return answer
    }
    
    private func outputToLabel(output: [Float]) -> UInt8? {
        guard let max = output.max() else {
            return nil
        }
        return UInt8(output.index(of: max)!)
    }
    
}

class HandwritingLearner {
    
    let network = FFNN(inputs: 10, hidden: 56, outputs: 784, learningRate: 1.0, momentum: 0.5, weights: nil, activationFunction: .Sigmoid, errorFunction: .crossEntropy(average: true))
    var trainImages = [[Float]]()
    var trainLabels = [UInt8]()
    var testImages = [[Float]]()
    var testLabels = [UInt8]()
    
    func extractTrainingData() {
        print("Extracting training data...")
        // Create variables for storing data
        var trainImages = [[Float]]()
        var trainLabels = [UInt8]()
        var testImages = [[Float]]()
        var testLabels = [UInt8]()
        // Define image size
        let numTrainImages = 60_000
        let numTestImages = 10_000
        let imageSize = CGSize(width: 28, height: 28)
        let numPixels = Int(imageSize.width * imageSize.height)
        // Extract training data
        let executablePath = Bundle.main.executablePath!
        let projectURL = NSURL(fileURLWithPath: executablePath).deletingLastPathComponent!
        let trainImagesURL = projectURL.appendingPathComponent("train-images-idx3-ubyte")
        let trainImagesData = NSData(contentsOf: trainImagesURL)!
        // Extract testing data
        let testImagesURL = projectURL.appendingPathComponent("t10k-images-idx3-ubyte")
        let testImagesData = NSData(contentsOf: testImagesURL)!
        // Extract training labels
        let trainLabelsURL = projectURL.appendingPathComponent("train-labels-idx1-ubyte")
        let trainLablelsData = NSData(contentsOf: trainLabelsURL)!
        // Extract testing labels
        let testLabelsURL = projectURL.appendingPathComponent("t10k-labels-idx1-ubyte")
        let testLablelsData = NSData(contentsOf: testLabelsURL)!
        // Store image/label byte indices
        var imagePosition = 16 // Start after header info
        var labelPosition = 8 // Start after header info
        for imageIndex in 0..<numTrainImages {
            if imageIndex % 10_000 == 0 || imageIndex == numTrainImages - 1 {
                print("\((imageIndex + 1) * 100 / numTrainImages)%")
            }
            // Extract training image pixels
            var trainPixelsArray = [UInt8](repeating: 0, count: numPixels)
            trainImagesData.getBytes(&trainPixelsArray, range: NSMakeRange(imagePosition, numPixels))
            // Convert pixels to Floats
            var trainPixelsFloatArray = [Float](repeating: 0, count: numPixels)
            for (index, pixel) in trainPixelsArray.enumerated() {
                trainPixelsFloatArray[index] = Float(pixel) / 255
            }
            // Append image to array
            trainImages.append(trainPixelsFloatArray)
            // Extract labels
            var trainLabel = [UInt8](repeating: 0, count: 1)
            trainLablelsData.getBytes(&trainLabel, range: NSMakeRange(labelPosition, 1))
            // Append label to array
            trainLabels.append(trainLabel.first!)
            // Extract test image/label if we're still in range
            if imageIndex < numTestImages {
                // Extract test image pixels
                var testPixelsArray = [UInt8](repeating: 0, count: numPixels)
                testImagesData.getBytes(&testPixelsArray, range: NSMakeRange(imagePosition, numPixels))
                // Convert pixels to Floats
                var testPixelsFloatArray = [Float](repeating: 0, count: numPixels)
                for (index, pixel) in testPixelsArray.enumerated() {
                    testPixelsFloatArray[index] = Float(pixel) / 255
                }
                // Append image to array
                testImages.append(testPixelsFloatArray)
                // Extract labels
                var testLabel = [UInt8](repeating: 0, count: 1)
                testLablelsData.getBytes(&testLabel, range: NSMakeRange(labelPosition, 1))
                // Append label to array
                testLabels.append(testLabel.first!)
            }
            // Increment counters
            imagePosition += numPixels
            labelPosition += 1
        }
        self.trainImages = trainImages
        self.trainLabels = trainLabels
        self.testImages = testImages
        self.testLabels = testLabels
    }
    
    func trainNetwork() {
        print("\nTraining neural network...")
        // Convert training labels into Float answer arrays
        var trainLabelArrays = [[Float]]()
        for label in self.trainLabels {
            trainLabelArrays.append(self.labelToArray(label: label))
        }
        var testLabelArrays = [[Float]]()
        for label in self.testLabels {
            testLabelArrays.append(self.labelToArray(label: label))
        }
        do {
            print("\nBefore training:")
            var errorSum: Float = 0
            for (index, labelArray) in testLabelArrays.enumerated() {
                let outputArray = try self.network.update(inputs: labelArray)
                let answerArray = self.testImages[index]
                errorSum += self.calculateError(output: outputArray, answer: answerArray)
            }
            print("Error sum: \(errorSum)")
            
            var epoch = 1
            while true {
                print("\nEpoch \(epoch): Learning rate \(self.network.learningRate)")
                for (index, labelArray) in trainLabelArrays.enumerated() {
                    try self.network.update(inputs: labelArray)
                    let answer = self.trainImages[index]
                    try self.network.backpropagate(answer: answer)
                }
                var errorSum: Float = 0
                for (index, labelArray) in testLabelArrays.enumerated() {
                    let outputArray = try self.network.update(inputs: labelArray)
                    let answerArray = self.testImages[index]
                    errorSum += self.calculateError(output: outputArray, answer: answerArray)
                }
                print("Error sum: \(errorSum)")
                self.network.learningRate *= 0.75
                self.network.momentumFactor *= 0.75
                if epoch == 5 {
                    self.network.writeToFile("handwriting-learn-ffnn")
                    break
                }
                epoch += 1
            }
        } catch {
            print(error)
        }
        print("\nTraining completed! Neural network stored at ~/Documents/handwriting-ffnn")
    }
    
    private func calculateError(output: [Float], answer: [Float]) -> Float {
        var error: Float = 0
        for (index, element) in output.enumerated() {
            error += abs(element - answer[index])
        }
        return error
    }
    
    private func labelToArray(label: UInt8) -> [Float] {
        var answer = [Float](repeating: 0, count: 10)
        answer[Int(label)] = 1
        return answer
    }
    
    private func outputToLabel(output: [Float]) -> UInt8? {
        guard let max = output.max() else {
            return nil
        }
        return UInt8(output.index(of: max)!)
    }
    
}

func handwriting() {
    
    let handwritingTrainer = HandwritingTrainer()
    handwritingTrainer.extractTrainingData()
    handwritingTrainer.trainNetwork()
    
//    let handwritingLearner = HandwritingLearner()
//    handwritingLearner.extractTrainingData()
//    handwritingLearner.trainNetwork()
    
}

