//
//  HandwritingViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/3/15.
//

import UIKit

class HandwritingViewController: UIViewController {
    
    var network: FFNN!
    let brushWidth: CGFloat = 25
    
    // Drawing state variables
    private var lastDrawPoint = CGPointZero
    private var boundingBox: CGRect?
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
        let location = touch.locationInView(self.handwritingView.canvas)
        if self.boundingBox == nil {
            self.boundingBox = CGRect(x: location.x - self.brushWidth / 2,
                y: location.y - self.brushWidth / 2,
                width: self.brushWidth,
                height: self.brushWidth)
        }
        self.lastDrawPoint = location
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
        if currentPoint.x < self.boundingBox!.minX {
            self.updateRect(&self.boundingBox!, minX: currentPoint.x - self.brushWidth - 20, maxX: nil, minY: nil, maxY: nil)
        } else if currentPoint.x > self.boundingBox!.maxX {
            self.updateRect(&self.boundingBox!, minX: nil, maxX: currentPoint.x + self.brushWidth + 20, minY: nil, maxY: nil)
        }
        if currentPoint.y < self.boundingBox!.minY {
            self.updateRect(&self.boundingBox!, minX: nil, maxX: nil, minY: currentPoint.y - self.brushWidth - 20, maxY: nil)
        } else if currentPoint.y > self.boundingBox!.maxY {
            self.updateRect(&self.boundingBox!, minX: nil, maxX: nil, minY: nil, maxY: currentPoint.y + self.brushWidth + 20)
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
        self.boundingBox = nil
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
            if let (label, confidence) = self.outputToLabel(output) {
                self.updateOutputLabels("\(label)", confidence: "\((confidence * 100).toString(decimalPlaces: 2))%")
            } else {
                self.handwritingView.outputLabel.text = "Error"
            }
        } catch {
            print(error)
        }
        
        // Clear the canvas
        self.clearCanvas()
    }
    
    private func updateOutputLabels(output: String, confidence: String) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.handwritingView.outputLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
            self.handwritingView.outputLabel.text = output
            self.handwritingView.confidenceLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
            self.handwritingView.confidenceLabel.text = confidence
        }, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.handwritingView.outputLabel.transform = CGAffineTransformIdentity
            self.handwritingView.confidenceLabel.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    private func outputToLabel(output: [Float]) -> (label: Int, confidence: Double)? {
        guard let max = output.maxElement() else {
            return nil
        }
        return (output.indexOf(max)!, Double(max / 1.0))
    }
    
    private func scanImage() -> [Float]? {
        var pixelsArray = [Float]()
        guard let image = self.handwritingView.canvas.image else {
            return nil
        }
        // Extract drawing from canvas and remove surrounding whitespace
        let croppedImage = self.cropImage(image, toRect: self.boundingBox!)
        // Scale character to max 20px in either dimension
        let scaledImage = self.scaleImageToSize(croppedImage, maxLength: 20)
        // Center character in 28x28 white box
        let character = self.addBorderToImage(scaledImage)
        
        self.handwritingView.imageView.image = character
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(character.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerRow = CGImageGetBytesPerRow(character.CGImage)
        let bytesPerPixel = (CGImageGetBitsPerPixel(character.CGImage) / 8)
        var position = 0
        for _ in 0..<Int(character.size.height) {
            for _ in 0..<Int(character.size.width) {
                let alpha = Float(data[position + 3])
                pixelsArray.append(alpha / 255)
                position += bytesPerPixel
            }
            if position % bytesPerRow != 0 {
                position += (bytesPerRow - (position % bytesPerRow))
            }
        }
        return pixelsArray
    }
    
    private func cropImage(image: UIImage, toRect: CGRect) -> UIImage {
        let imageRef = CGImageCreateWithImageInRect(image.CGImage!, toRect)
        let newImage = UIImage(CGImage: imageRef!)
        return newImage
    }
    
    private func scaleImageToSize(image: UIImage, maxLength: CGFloat) -> UIImage {
        let size = CGSize(width: min(20 * image.size.width / image.size.height, 20), height: min(20 * image.size.height / image.size.width, 20))
        let newRect = CGRectIntegral(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, CGInterpolationQuality.None)
        image.drawInRect(newRect)
        let newImageRef = CGBitmapContextCreateImage(context)! as CGImage
        let newImage = UIImage(CGImage: newImageRef, scale: 1.0, orientation: UIImageOrientation.Up)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func addBorderToImage(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 28, height: 28))
        let white = UIImage(named: "white")!
        white.drawAtPoint(CGPointZero)
        image.drawAtPoint(CGPointMake((28 - image.size.width) / 2, (28 - image.size.height) / 2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func clearCanvas() {
        // Show snapshot box
        if let box = self.boundingBox {
            self.handwritingView.snapshotBox.frame = box
            self.handwritingView.snapshotBox.transform = CGAffineTransformMakeScale(0.96, 0.96)
            UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                self.handwritingView.snapshotBox.alpha = 1
                self.handwritingView.snapshotBox.transform = CGAffineTransformMakeScale(1.06, 1.06)
            }, completion: nil)
            UIView.animateWithDuration(0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                self.handwritingView.snapshotBox.transform = CGAffineTransformIdentity
            }, completion: nil)
        }
        
        UIView.animateWithDuration(0.1, delay: 0.4, options: [.CurveEaseIn], animations: { () -> Void in
            self.handwritingView.canvas.alpha = 0
            self.handwritingView.snapshotBox.alpha = 0
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
    
    private func updateRect(inout rect: CGRect, minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) {
        rect = CGRect(x: minX ?? rect.minX,
            y: minY ?? rect.minY,
            width: (maxX ?? rect.maxX) - (minX ?? rect.minX),
            height: (maxY ?? rect.maxY) - (minY ?? rect.minY))
    }

}
