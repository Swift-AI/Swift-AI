//
//  HandwritingViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/3/15.
//

import UIKit

class HandwritingViewController: UIViewController {
    
    let networkQueue = dispatch_queue_create("networkQueue", DISPATCH_QUEUE_SERIAL)
    var network: FFNN!
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
        
        let url = NSBundle.mainBundle().URLForResource("handwriting-ffnn", withExtension: nil)!
        self.network = FFNN.fromFile(url)

        self.handwritingView.startPauseButton.addTarget(self, action: "startPause", forControlEvents: .TouchUpInside)
        self.handwritingView.clearButton.addTarget(self, action: "resetTapped", forControlEvents: .TouchUpInside)
        self.handwritingView.infoButton.addTarget(self, action: "infoTapped", forControlEvents: .TouchUpInside)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        // Nothing right now
    }
    
    func resetTapped() {
        self.clearCanvas()
    }
    
    func infoTapped() {
        let infoView = InfoView()
        DrawerNavigationController.globalDrawerController().presentInfoView(infoView)
    }
    
    func timerExpired(sender: NSTimer) {
        self.classifyImage()
    }

}

// MARK:- Classification and drawing methods

extension HandwritingViewController {
    
    private func classifyImage() {
        // Extract and resize image from drawing canvas
        guard let imageArray = self.scanImage() else {
            self.clearCanvas()
            return
        }
        do {
            let output = try self.network.update(inputs: imageArray)
            if let label = self.outputToLabel(output) {
                self.handwritingView.outputLabel.text = "\(label)"
            } else {
                self.handwritingView.outputLabel.text = "Error"
            }
        } catch {
            print(error)
        }
        
        // Clear the canvas
        self.clearCanvas()
    }
    
    private func outputToLabel(output: [Float]) -> Int? {
        guard let max = output.maxElement() else {
            return nil
        }
        return output.indexOf(max)
    }
    
    private func scanImage() -> [Float]? {
        var inputArray = [Float]()
        var pixelsArray = [[Float]]()
        guard let image = self.handwritingView.canvas.image else {
            return nil
        }
        let scaledImage = self.scaleImageToSize(image: image, size: CGSize(width: 28, height: 28))
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(scaledImage.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerRow = CGImageGetBytesPerRow(scaledImage.CGImage)
        let bytesPerPixel = (CGImageGetBitsPerPixel(scaledImage.CGImage) / 8)
        var position = 0
        for _ in 0..<Int(scaledImage.size.height) {
            var columnArray = [Float]()
            for _ in 0..<Int(scaledImage.size.width) {
//                let red = CGFloat(data[position])
//                let green = CGFloat(data[position + 1])
//                let blue = CGFloat(data[position + 2])
                let alpha = CGFloat(data[position + 3])
//                let gray = 1.0 - Float(((red / 255) + (green / 255) + (blue / 255)) / 3)
                columnArray.append(alpha == 0 ? Float(alpha) : 1.0)
                position += bytesPerPixel
            }
            pixelsArray.append(columnArray)
            if position % bytesPerRow != 0 {
                position += (bytesPerRow - (position % bytesPerRow))
            }
        }
        // Rearrange pixels into rows instead of columns
        let numRows = pixelsArray[0].count
        for row in 0..<numRows {
            for column in pixelsArray {
                inputArray.append(column[row])
            }
        }
        // inputArray: Pixels are ordered Left->Right, Top->Bottom
        return inputArray
    }
    
    private func scaleImageToSize(image image: UIImage, size: CGSize) -> UIImage {
        let newRect = CGRectIntegral(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let imageRef = image.CGImage
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, CGInterpolationQuality.None) // kCGInterpolationNone)
        CGContextDrawImage(context, newRect, imageRef)
        let newImageRef = CGBitmapContextCreateImage(context)! as CGImage
        let newImage = UIImage(CGImage: newImageRef, scale: 1.0, orientation: UIImageOrientation.DownMirrored)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func clearCanvas() {
        UIView.animateWithDuration(0.1, delay: 0, options: [.CurveEaseIn], animations: { () -> Void in
            self.handwritingView.canvas.alpha = 0
            }) { (Bool) -> Void in
                self.handwritingView.canvas.image = nil
                self.handwritingView.canvas.alpha = 1
        }
    }
    
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
