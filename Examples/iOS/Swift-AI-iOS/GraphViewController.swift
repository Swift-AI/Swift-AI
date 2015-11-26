//
//  GraphViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/22/15.
//

import UIKit
import APKit

class GraphViewController: UIViewController {
    
    let graphView = GraphView()
    /// The number of points to plot on screen
    var numPoints = 0
    /// Array of each point to display in the graph
    var points = [UIView]()
    /// Our neural network
    var network = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.6, momentum: 0.8, weights: nil, activationFunction: .Sigmoid)
    /// A multiplier, for altering the target function
    var functionMultiplier: Float = 1.5
    /// State variable to start/stop the network's training when needed
    var paused = true
    
    override func loadView() {
        self.view = self.graphView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure buttons
        self.graphView.startPauseButton.addTarget(self, action: "startPause", forControlEvents: .TouchUpInside)
        self.graphView.resetButton.addTarget(self, action: "resetAll", forControlEvents: .TouchUpInside)
        // Configure slider for multiplier
        self.graphView.slider.addTarget(self, action: "sliderMoved:", forControlEvents: .ValueChanged)
        // Set function label text
        self.graphView.functionLabel.text = "y = ½ sin(\(self.functionMultiplier)x) + ½"
        // Calculate number of points to plot, based on screen size (#hack)
        self.numPoints = Int(UIScreen.mainScreen().bounds.width / 2)
        
        self.resetAll()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.graphView.startPauseButton.setTitle("Start", forState: .Normal)
        self.pauseTraining()
    }
    
    func startPause() {
        switch self.paused {
        case true:
            self.graphView.startPauseButton.setTitle("Pause", forState: .Normal)
            self.startTraining()
        case false:
            self.graphView.startPauseButton.setTitle("Start", forState: .Normal)
            self.pauseTraining()
        }
    }
    
    func sliderMoved(sender: UISlider) {
        self.functionMultiplier = sender.value
        let constantString = Double(self.functionMultiplier).toString(decimalPlaces: 1)
        self.graphView.functionLabel.text = "y = ½ sin(" + constantString + "x) + ½"
    }
    
    func startTraining() {
        self.paused = false
        // Dispatches training process to background thread, to keep UI responsive
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            var epoch = 0
            while !self.paused {
                for index in 0..<self.numPoints {
                    let x = (-500 + (Float(index) * 1000) / Float(self.numPoints)) / 100
                    try! self.network.update(inputs: [x])
                    let answer = self.sineFunc(x)
                    try! self.network.backpropagate(answer: [answer])
                }
                if epoch % 10 == 0 {
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        for index in 0..<self.numPoints {
                            let xScaled = -500 + Float(index) * 1000 / Float(self.numPoints)
                            let x = xScaled / 100
                            let y = try! self.network.update(inputs: [x]).first!
                            self.updatePoint(index, y: CGFloat(y * -200))
                        }
                    })
                }
                ++epoch
            }
        }
    }
    
    func pauseTraining() {
        self.paused = true
    }
    
    func resetAll() {
        self.initPoints()
        self.resetNetwork()
    }
    
    // MARK:- Private methods
    
    /// Creates a new set of points to plot on screen
    private func initPoints() {
        // Remove all points first, in case this is a reset
        for point in self.points {
            point.removeFromSuperview()
        }
        self.points.removeAll()
        for index in 0..<self.numPoints {
            // Create a point
            let point = UIView()
            // Calculate position to place point
            let xPos = CGFloat(index) * (UIScreen.mainScreen().bounds.width / CGFloat(self.numPoints))
            let yPos = UIScreen.mainScreen().bounds.height / 2
            // Add point to view
            point.frame = CGRect(x: xPos, y: yPos, width: 8, height: 8)
            point.backgroundColor = .swiftDarkOrange()
            point.layer.cornerRadius = 4
            self.graphView.addSubview(point)
            // Store point
            self.points.append(point)
        }
    }
    
    /// Resets the neural network, with new random weights
    private func resetNetwork() {
        self.network = FFNN(inputs: 1, hidden: 10, outputs: 1, learningRate: 0.5, momentum: 0.8, weights: nil, activationFunction: .Sigmoid)
    }
    
    /// Translates a the point at the given index to the specified y-value
    private func updatePoint(index: Int, y: CGFloat) {
        self.points[index].transform = CGAffineTransformMakeTranslation(0, y)
    }
    
    /// The sine wave function for regression
    private func sineFunc(x: Float) -> Float {
        return (0.5 * sin(self.functionMultiplier * x)) + 0.5
    }
}

