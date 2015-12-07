//
//  HandwritingViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/3/15.
//

import UIKit

class HandwritingViewController: UIViewController {
    
    let network = FFNN(inputs: 784, hidden: 560, outputs: 10, learningRate: 0.7, momentum: 0.1, weights: nil, activationFunction: .Sigmoid, errorFunction: .CrossEntropy(average: true))
    var images = [[Float]]()
    var labels = [UInt8]()
    
    let brushWidth: CGFloat = 15.0
    
    // Drawing state variables
    private var lastDrawPoint = CGPointZero
    private var swiped = false
    private var drawing = false
    private var timer = NSTimer()
    
    let handwritingView = HandwritingView()
    
    override func loadView() {
        self.view = self.handwritingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handwritingView.startPauseButton.addTarget(self, action: "startPause", forControlEvents: .TouchUpInside)
        self.handwritingView.clearButton.addTarget(self, action: "clearCanvas", forControlEvents: .TouchUpInside)
        self.handwritingView.infoButton.addTarget(self, action: "infoTapped", forControlEvents: .TouchUpInside)
        
//        (self.images, self.labels) = self.extractTrainingData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first  else {
            return
        }
        self.swiped = false
        guard CGRectContainsPoint(self.handwritingView.canvas.frame, touch.locationInView(self.handwritingView)) else {
            super.touchesBegan(touches, withEvent: event)
            return
        }
        self.timer.invalidate()
        self.lastDrawPoint = touch.locationInView(self.handwritingView.canvas)
        self.drawing = true
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first  else {
            return
        }
        guard CGRectContainsPoint(self.handwritingView.canvas.frame, touch.locationInView(self.handwritingView)) else {
            super.touchesMoved(touches, withEvent: event)
            self.swiped = false
            return
        }
        let currentPoint = touch.locationInView(self.handwritingView.canvas)
        if self.swiped {
            self.drawLine(fromPoint: self.lastDrawPoint, toPoint: currentPoint)
        } else {
            self.drawLine(fromPoint: currentPoint, toPoint: currentPoint)
            self.swiped = true
        }
        self.lastDrawPoint = currentPoint
        self.timer.invalidate()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first  else {
            return
        }
        if CGRectContainsPoint(self.handwritingView.canvas.frame, touch.locationInView(self.handwritingView)) {
            if !self.swiped {
                // Draw dot
                self.drawLine(fromPoint: self.lastDrawPoint, toPoint: self.lastDrawPoint)
            }
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "timerExpired:", userInfo: nil, repeats: false)
        self.drawing = false
        super.touchesEnded(touches, withEvent: event)
    }
    
    func startPause() {
        
        
        
    }
    
    func clearCanvas() {
        UIView.animateWithDuration(0.1, delay: 0, options: [.CurveEaseIn], animations: { () -> Void in
            self.handwritingView.canvas.alpha = 0
        }) { (Bool) -> Void in
            self.handwritingView.canvas.image = nil
            self.handwritingView.canvas.alpha = 1
        }
    }
    
    func infoTapped() {
        let infoView = InfoView()
        DrawerNavigationController.globalDrawerController().presentInfoView(infoView)
    }
    
    func timerExpired(sender: NSTimer) {
//        self.clearCanvas()
    }

    
    
    // MARK:- Private methods
    
    private func drawLine(fromPoint fromPoint: CGPoint, toPoint: CGPoint) {
        // Begin context
        UIGraphicsBeginImageContext(self.handwritingView.canvas.frame.size)
        let context = UIGraphicsGetCurrentContext()
        // Store current image (lines drawn) in context
        self.handwritingView.canvas.image?.drawInRect(CGRect(x: 0, y: 0, width: self.handwritingView.canvas.frame.width, height: self.handwritingView.canvas.frame.height))
        // Append new line to image
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, self.brushWidth)
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        CGContextStrokePath(context)
        // Store modified image back to imageView
        self.handwritingView.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        // End context
        UIGraphicsEndImageContext()
    }
    
}

// MARK:- Training methods

extension HandwritingViewController {
    
    private func extractTrainingData() -> (images: [[Float]], labels: [UInt8]) {
        // Create variables for storing data
        var images = [[Float]]()
        var labels = [UInt8]()
        // Define image size
        let numImages = 60_000
        let imageSize = CGSize(width: 28, height: 28)
        let numPixels = Int(imageSize.width * imageSize.height)
        // Extract training data
        let trainImagesURL = NSBundle.mainBundle().URLForResource("train-images-idx3-ubyte", withExtension: nil)!
        let trainImagesData = NSData(contentsOfURL: trainImagesURL)!
        // Extract training labels
        let trainLabelsURL = NSBundle.mainBundle().URLForResource("train-images-idx3-ubyte", withExtension: nil)!
        let trainLablelsData = NSData(contentsOfURL: trainLabelsURL)!
        // Store image/label byte indices
        var trainImageIndex = 16 // Start after header info
        var trainLabelIndex = 8 // Start after header info
        for _ in 0..<numImages {
            // Extract image pixels
            var pixelsArray = [UInt8](count: numPixels, repeatedValue: 0)
            trainImagesData.getBytes(&pixelsArray, range: NSMakeRange(trainImageIndex, numPixels))
            // Convert pixels to Floats
            var pixelsFloatArray = [Float]()
            for pixel in pixelsArray {
                pixelsFloatArray.append(Float(pixel) / 255)
            }
            // Append image to array
            images.append(pixelsFloatArray)
            // Extract labels
            var label = [UInt8](count: 1, repeatedValue: 0)
            trainLablelsData.getBytes(&label, range: NSMakeRange(trainLabelIndex, 1))
            // Append label to array
            labels.append(label.first!)
            // Increment counters
            trainImageIndex += numPixels
            trainLabelIndex++
        }
        return (images, labels)
    }

}
