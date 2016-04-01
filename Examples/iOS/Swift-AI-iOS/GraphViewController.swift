//
//  GraphViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/22/15.
//

import UIKit

class GraphViewController: UIViewController {
    
    let graphView = GraphView()
    /// The number of points to plot on screen
    var numPoints = 0
    /// Array of all points to display in the graph
    var points = [CALayer]()
    /// Our neural network
    private var network = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.6, momentum: 0.8, weights: nil, activationFunction: .Sigmoid, errorFunction: .Default(average: false))
    /// Serial queue for synchronizing access to neural network from multiple threads
    private let networkQueue = dispatch_queue_create("com.SwiftAI.networkQueue", DISPATCH_QUEUE_SERIAL)
    /// A multiplier, for altering the target function
    private var functionMultiplier: Float = 1.5 {
        didSet {
            self.updateFunctionLabel()
            self.updateTarget()
        }
    }
    private var functionOffset: Float = 0.0 {
        didSet {
            self.updateFunctionLabel()
            self.updateTarget()
        }
    }
    /// State variable to start/stop the network's training when needed
    private var paused = true
    /// State variable to resume trainig after a reset, if needed
    private var toContinue = false
    
    override func loadView() {
        self.view = self.graphView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure buttons
        self.graphView.startPauseButton.addTarget(self, action: #selector(startPause), forControlEvents: .TouchUpInside)
        self.graphView.infoButton.addTarget(self, action: #selector(infoTapped), forControlEvents: .TouchUpInside)
        self.graphView.resetButton.addTarget(self, action: #selector(resetAll), forControlEvents: .TouchUpInside)
        // Configure slider for multiplier
        self.graphView.frequencySlider.addTarget(self, action: #selector(frequencySliderMoved), forControlEvents: .ValueChanged)
        self.graphView.offsetSlider.addTarget(self, action: #selector(offsetSliderMoved), forControlEvents: .ValueChanged)
        // Set function label text
        self.graphView.functionLabel.setTitle("y = sin (\(self.functionMultiplier)x)", forState: .Normal)
        // Calculate number of points to plot, based on screen size (#hack)
        self.numPoints = Int((UIScreen.mainScreen().bounds.width - 20))// / 2) // -20 for margins
    }
    
    override func viewDidAppear(animated: Bool) {
        // Happens here so we have a frame for our CGContext to draw curves
        self.resetAll()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.graphView.startPauseButton.setImage(UIImage(named: "play"), forState: .Normal)
        self.graphView.startPauseButton.setImage(UIImage(named: "play_highlighted"), forState: .Highlighted)
        self.graphView.startPauseButton.backgroundColor = UIColor.swiftGreen()
        self.pauseTraining()
    }
    
    func startPause() {
        switch self.paused {
        case true:
            self.graphView.startPauseButton.setImage(UIImage(named: "pause"), forState: .Normal)
            self.graphView.startPauseButton.setImage(UIImage(named: "pause_highlighted"), forState: .Highlighted)
            self.graphView.startPauseButton.backgroundColor = UIColor.swiftDarkOrange()
            self.startTraining()
        case false:
            self.graphView.startPauseButton.setImage(UIImage(named: "play"), forState: .Normal)
            self.graphView.startPauseButton.setImage(UIImage(named: "play_highlighted"), forState: .Highlighted)
            self.graphView.startPauseButton.backgroundColor = UIColor.swiftGreen()
            self.pauseTraining()
        }
    }
    
    func frequencySliderMoved(sender: UISlider) {
        self.functionMultiplier = sender.value
    }
    
    func offsetSliderMoved(sender: UISlider) {
        self.functionOffset = sender.value
    }
    
    func startTraining() {
        self.paused = false
        // Dispatches training process to background thread
        dispatch_async(self.networkQueue) {
            var epoch = 0
            while !self.paused {
                for index in 0..<self.numPoints {
                    let x = (-500 + (Float(index) * 1000) / Float(self.numPoints)) / 100
                    try! self.network.update(inputs: [x])
                    let answer = self.sineFunc(x)
                    try! self.network.backpropagate(answer: [answer])
                }
                if epoch % 2 == 0 {
                    let ys = self.computePoints()
                    dispatch_sync(dispatch_get_main_queue()) {
                        self.updatePoints(ys)
                    }
                }
                epoch += 1
            }
        }
    }
    
    func pauseTraining() {
        self.paused = true
    }
    
    func resetAll() {
        self.toContinue = !self.paused
        self.pauseTraining()
        self.resetNetwork()
        self.updateTarget()
        self.initPoints()
    }
    
    func infoTapped() {
        // Pause training if it's currently running
        if !self.paused {
            self.startPause()
        }
        // Present info view 
        let infoView = InfoView()
        infoView.label1.text = "What does it do?"
        infoView.field1.text = "This is an Artificial Neural Network. Here we train it to learn the Sine function."
        infoView.label2.text = "How do I use it?"
        infoView.field2.text = "The green wave is the function we'd like to model, the red wave is the neural network's output. Here we watch the network's learning process - live - on the graph.\n\n - Tap 'Start' to begin the training \n - Tap 'Pause' to pause the training\n - Tap 'Reset' to create a new network\n - Adjust the sliders to change the target"
        infoView.label3.text = "How does it work?"
        infoView.field3.text = "For each X coordinate on the graph, the neural network 'guesses' the Y value. The error is then propagated through the network, and over time our model converges closer to the target function."
        DrawerNavigationController.globalDrawerController().presentInfoView(infoView)
    }
    
    // MARK:- Private methods
    
    /// Update Function Label
    private func updateFunctionLabel() {
        let frequencyString = Double(self.functionMultiplier).toString(decimalPlaces: 1)
        let phaseString =  (self.functionOffset > 0.0) ? " + " + Double(self.functionOffset).toString(decimalPlaces: 1) + "π" : ""
        self.graphView.functionLabel.setTitle("y = sin (\(frequencyString)x\(phaseString))", forState: .Normal)
    }
    
    /// Creates a new set of points to plot on screen
    private func initPoints() {
        // Remove all points first, in case this is a reset
        for point in self.points {
            point.removeFromSuperlayer()
        }
        self.points.removeAll()
        for index in 0..<self.numPoints {
            // Create a point
            let point = CALayer()
            // Calculate position to place point
            let xPos = CGFloat(index) * ((UIScreen.mainScreen().bounds.width - 20) / CGFloat(self.numPoints)) - 3 // *.99 so points don't overflow
            let yPos = (UIScreen.mainScreen().bounds.width - 20) / 2 - 4 // -20 for gray margins; -4 to offset point height
            // Add point to view
            point.frame = CGRect(x: xPos, y: yPos, width: 6, height: 6)
            point.backgroundColor = UIColor.swiftDarkOrange().CGColor
            point.cornerRadius = 3
            // Remove implicit transform animations
            point.actions = ["transform" : NSNull()]
            self.graphView.graphContainer.layer.insertSublayer(point, below: self.graphView.negXLabel.layer)
            // Store point
            self.points.append(point)
        }
        
        // Update the points on screen
        dispatch_async(self.networkQueue) {
            let ys = self.computePoints()
            dispatch_sync(dispatch_get_main_queue()) {
                self.updatePoints(ys)
            }
        }
    }

    private func updateTarget() {
        // Begin context
        UIGraphicsBeginImageContext(self.graphView.graphTargetView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        // Set initial drawing position
        let startY = self.sineFunc(-5) // Our graph starts at '-5'
        let yOrigin = (UIScreen.mainScreen().bounds.width - 20) / 2 - 4
        let yPos = yOrigin + (CGFloat(startY * -250) + 125) // Offset
        CGContextMoveToPoint(context, 0, CGFloat(yPos))
        for index in 0..<self.numPoints {
            // Append new line to curve
            let x = (-500 + (Float(index) * 1000) / Float(self.numPoints)) / 100
            let y = self.sineFunc(x)
            let xPos = CGFloat(index) * ((UIScreen.mainScreen().bounds.width - 20) / CGFloat(self.numPoints)) * 0.99
            let yPos = yOrigin + CGFloat(y * -250) + 125
            CGContextAddLineToPoint(context, CGFloat(xPos), CGFloat(yPos))
        }
        // Set line properties
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, 2)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        UIColor.swiftGreen().getRed(&red, green: &green, blue: &blue, alpha: nil)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1)
        CGContextStrokePath(context)
        // Store modified image back to imageView
        self.graphView.graphTargetView.image = UIGraphicsGetImageFromCurrentImageContext()
        // End context
        UIGraphicsEndImageContext()
    }
    
    /// Resets the neural network, with new random weights.
    private func resetNetwork() {
        dispatch_async(self.networkQueue) { () -> Void in
            self.network = FFNN(inputs: 1, hidden: 10, outputs: 1, learningRate: 0.6, momentum: 0.8, weights: nil, activationFunction: .Sigmoid, errorFunction: .Default(average: false))
            if self.toContinue {
                // Continue training if it was previously running
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.startTraining()
                })
                self.toContinue = false
            }
        }
    }
    
    /// Returns new y coordinates for each point from the network.
    /// Note: must be called from the network queue.
    private func computePoints() -> [CGFloat] {
        return (0..<self.numPoints).map { index -> CGFloat in
            let x = (-500 + (Float(index) * 1000) / Float(self.numPoints)) / 100
            let networkY = try! self.network.update(inputs: [x]).first!
            return CGFloat(networkY * -250) + 125
        }
    }
    
    /// Updates the points on screen with the given y coordinates.
    /// Note: must be called from the main queue
    private func updatePoints(ys: [CGFloat]) {
        for index in 0..<self.numPoints {
            self.points[index].transform = CATransform3DMakeTranslation(0, ys[index], 0)
        }
    }
    
    /// The sine wave function for regression
    private func sineFunc(x: Float) -> Float {
        return (0.5 * sin(self.functionMultiplier * x + functionOffset * Float(M_PI))) + 0.5
    }
}

