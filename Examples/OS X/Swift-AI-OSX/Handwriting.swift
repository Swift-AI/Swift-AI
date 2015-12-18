//
//  Handwriting.swift
//  Swift-AI-OSX
//
//  Created by Collin Hundley on 12/15/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import Foundation

class HandwritingTrainer {
    
    let network = FFNN(inputs: 784, hidden: 280, outputs: 10, learningRate: 1.0, momentum: 0.5, weights: nil, activationFunction: .Sigmoid, errorFunction: .CrossEntropy(average: true))
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
        let executablePath = NSBundle.mainBundle().executablePath!
        let projectURL = NSURL(fileURLWithPath: executablePath).URLByDeletingLastPathComponent!
        let trainImagesURL = projectURL.URLByAppendingPathComponent("train-images-idx3-ubyte")
        let trainImagesData = NSData(contentsOfURL: trainImagesURL)!
        // Extract testing data
        let testImagesURL = projectURL.URLByAppendingPathComponent("t10k-images-idx3-ubyte")
        let testImagesData = NSData(contentsOfURL: testImagesURL)!
        // Extract training labels
        let trainLabelsURL = projectURL.URLByAppendingPathComponent("train-labels-idx1-ubyte")
        let trainLablelsData = NSData(contentsOfURL: trainLabelsURL)!
        // Extract testing labels
        let testLabelsURL = projectURL.URLByAppendingPathComponent("t10k-labels-idx1-ubyte")
        let testLablelsData = NSData(contentsOfURL: testLabelsURL)!
        // Store image/label byte indices
        var imagePosition = 16 // Start after header info
        var labelPosition = 8 // Start after header info
        for imageIndex in 0..<numTrainImages {
            if imageIndex % 10_000 == 0 || imageIndex == numTrainImages - 1 {
                print("\((imageIndex + 1) * 100 / numTrainImages)%")
            }
            // Extract training image pixels
            var trainPixelsArray = [UInt8](count: numPixels, repeatedValue: 0)
            trainImagesData.getBytes(&trainPixelsArray, range: NSMakeRange(imagePosition, numPixels))
            // Convert pixels to Floats
            var trainPixelsFloatArray = [Float](count: numPixels, repeatedValue: 0)
            for (index, pixel) in trainPixelsArray.enumerate() {
                trainPixelsFloatArray[index] = Float(pixel) / 255
            }
            // Append image to array
            trainImages.append(trainPixelsFloatArray)
            // Extract labels
            var trainLabel = [UInt8](count: 1, repeatedValue: 0)
            trainLablelsData.getBytes(&trainLabel, range: NSMakeRange(labelPosition, 1))
            // Append label to array
            trainLabels.append(trainLabel.first!)
            // Extract test image/label if we're still in range
            if imageIndex < numTestImages {
                // Extract test image pixels
                var testPixelsArray = [UInt8](count: numPixels, repeatedValue: 0)
                testImagesData.getBytes(&testPixelsArray, range: NSMakeRange(imagePosition, numPixels))
                // Convert pixels to Floats
                var testPixelsFloatArray = [Float](count: numPixels, repeatedValue: 0)
                for (index, pixel) in testPixelsArray.enumerate() {
                    testPixelsFloatArray[index] = Float(pixel) / 255
                }
                // Append image to array
                testImages.append(testPixelsFloatArray)
                // Extract labels
                var testLabel = [UInt8](count: 1, repeatedValue: 0)
                testLablelsData.getBytes(&testLabel, range: NSMakeRange(labelPosition, 1))
                // Append label to array
                testLabels.append(testLabel.first!)
            }
            // Increment counters
            imagePosition += numPixels
            labelPosition++
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
            trainAnswers.append(self.labelToArray(label))
        }
        var testAnswers = [[Float]]()
        for label in self.testLabels {
            testAnswers.append(self.labelToArray(label))
        }
        do {
            print("\nBefore training:")
            var errorSum: Float = 0
            var correct: Float = 0
            var incorrect: Float = 0
            for (index, image) in self.testImages.enumerate() {
                let outputArray = try self.network.update(inputs: image)
                if let outputLabel = self.outputToLabel(outputArray) {
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
                for (index, image) in self.trainImages.enumerate() {
                    try self.network.update(inputs: image)
                    let answer = trainAnswers[index]
                    try self.network.backpropagate(answer: answer)
                }
                var errorSum: Float = 0
                var correct: Float = 0
                var incorrect: Float = 0
                for (index, image) in self.testImages.enumerate() {
                    let outputArray = try self.network.update(inputs: image)
                    if let outputLabel = self.outputToLabel(outputArray) {
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
    
    private func calculateError(output output: [Float], answer: [Float]) -> Float {
        var error: Float = 0
        for (index, element) in output.enumerate() {
            error += abs(element - answer[index])
        }
        return error
    }
    
    private func labelToArray(label: UInt8) -> [Float] {
        var answer = [Float](count: 10, repeatedValue: 0)
        answer[Int(label)] = 1
        return answer
    }
    
    private func outputToLabel(output: [Float]) -> UInt8? {
        guard let max = output.maxElement() else {
            return nil
        }
        return UInt8(output.indexOf(max)!)
    }
    
}

func handwriting() {
    
    let handwritingTrainer = HandwritingTrainer()
    handwritingTrainer.extractTrainingData()
    handwritingTrainer.trainNetwork()
    
}

