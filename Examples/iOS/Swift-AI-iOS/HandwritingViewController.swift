//
//  HandwritingViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/3/15.
//

import UIKit

class HandwritingViewController: UIViewController {
    
    var network: FFNN!
    let brushWidth: CGFloat = 20
    
    // Drawing state variables
    fileprivate var lastDrawPoint = CGPoint.zero
    fileprivate var boundingBox: CGRect?
    fileprivate var swiped = false
    fileprivate var drawing = false
    fileprivate var timer = Timer()
    
    let handwritingView = HandwritingView()
    
    override func loadView() {
        self.view = self.handwritingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(forResource: "handwriting-ffnn", withExtension: nil)!
        self.network = FFNN.fromFile(url)

        self.handwritingView.startPauseButton.addTarget(self, action: #selector(startPause), for: .touchUpInside)
        self.handwritingView.clearButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        self.handwritingView.infoButton.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first  else {
            return
        }
        self.swiped = false
        guard self.handwritingView.canvas.frame.contains(touch.location(in: self.handwritingView)) else {
            super.touchesBegan(touches, with: event)
            return
        }
        self.timer.invalidate()
        let location = touch.location(in: self.handwritingView.canvas)
        if self.boundingBox == nil {
            self.boundingBox = CGRect(x: location.x - self.brushWidth / 2,
                y: location.y - self.brushWidth / 2,
                width: self.brushWidth,
                height: self.brushWidth)
        }
        self.lastDrawPoint = location
        self.drawing = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first  else {
            return
        }
        guard self.handwritingView.canvas.frame.contains(touch.location(in: self.handwritingView)) else {
            super.touchesMoved(touches, with: event)
            self.swiped = false
            return
        }
        let currentPoint = touch.location(in: self.handwritingView.canvas)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first  else {
            return
        }
        if self.handwritingView.canvas.frame.contains(touch.location(in: self.handwritingView)) {
            if !self.swiped {
                // Draw dot
                self.drawLine(fromPoint: self.lastDrawPoint, toPoint: self.lastDrawPoint)
            }
        }
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(timerExpired), userInfo: nil, repeats: false)
        self.drawing = false
        super.touchesEnded(touches, with: event)
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
    
    func timerExpired(_ sender: Timer) {
        self.classifyImage()
        self.boundingBox = nil
    }

}

// MARK:- Classification and drawing methods

extension HandwritingViewController {
    
    fileprivate func classifyImage() {
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
    
    fileprivate func updateOutputLabels(_ output: String, confidence: String) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.handwritingView.outputLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.handwritingView.outputLabel.text = output
            self.handwritingView.confidenceLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.handwritingView.confidenceLabel.text = confidence
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.handwritingView.outputLabel.transform = CGAffineTransform.identity
            self.handwritingView.confidenceLabel.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    fileprivate func outputToLabel(_ output: [Float]) -> (label: Int, confidence: Double)? {
        guard let max = output.max() else {
            return nil
        }
        return (output.index(of: max)!, Double(max / 1.0))
    }
    
    fileprivate func scanImage() -> [Float]? {
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
        
        let pixelData = character.cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerRow = character.cgImage?.bytesPerRow
        let bytesPerPixel = ((character.cgImage?.bitsPerPixel)! / 8)
        var position = 0
        for _ in 0..<Int(character.size.height) {
            for _ in 0..<Int(character.size.width) {
                let alpha = Float(data[position + 3])
                pixelsArray.append(alpha / 255)
                position += bytesPerPixel
            }
            if position % bytesPerRow! != 0 {
                position += (bytesPerRow! - (position % bytesPerRow!))
            }
        }
        return pixelsArray
    }
    
    fileprivate func cropImage(_ image: UIImage, toRect: CGRect) -> UIImage {
        let imageRef = image.cgImage!.cropping(to: toRect)
        let newImage = UIImage(cgImage: imageRef!)
        return newImage
    }
    
    fileprivate func scaleImageToSize(_ image: UIImage, maxLength: CGFloat) -> UIImage {
        let size = CGSize(width: min(20 * image.size.width / image.size.height, 20), height: min(20 * image.size.height / image.size.width, 20))
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height).integral
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = CGInterpolationQuality.none
        image.draw(in: newRect)
        let newImageRef = (context?.makeImage()!)! as CGImage
        let newImage = UIImage(cgImage: newImageRef, scale: 1.0, orientation: UIImageOrientation.up)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    fileprivate func addBorderToImage(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 28, height: 28))
        let white = UIImage(named: "white")!
        white.draw(at: CGPoint.zero)
        image.draw(at: CGPoint(x: (28 - image.size.width) / 2, y: (28 - image.size.height) / 2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    fileprivate func clearCanvas() {
        // Show snapshot box
        if let box = self.boundingBox {
            self.handwritingView.snapshotBox.frame = box
            self.handwritingView.snapshotBox.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                self.handwritingView.snapshotBox.alpha = 1
                self.handwritingView.snapshotBox.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
            }, completion: nil)
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                self.handwritingView.snapshotBox.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.4, options: [.curveEaseIn], animations: { () -> Void in
            self.handwritingView.canvas.alpha = 0
            self.handwritingView.snapshotBox.alpha = 0
        }) { (Bool) -> Void in
            self.handwritingView.canvas.image = nil
            self.handwritingView.canvas.alpha = 1
        }
    }
    
    fileprivate func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        // Begin context
        UIGraphicsBeginImageContext(self.handwritingView.canvas.frame.size)
        let context = UIGraphicsGetCurrentContext()
        // Store current image (lines drawn) in context
        self.handwritingView.canvas.image?.draw(in: CGRect(x: 0, y: 0, width: self.handwritingView.canvas.frame.width, height: self.handwritingView.canvas.frame.height))
        // Append new line to image
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(self.brushWidth)
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        // Store modified image back to imageView
        self.handwritingView.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        // End context
        UIGraphicsEndImageContext()
    }
    
    fileprivate func updateRect(_ rect: inout CGRect, minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) {
        rect = CGRect(x: minX ?? rect.minX,
            y: minY ?? rect.minY,
            width: (maxX ?? rect.maxX) - (minX ?? rect.minX),
            height: (maxY ?? rect.maxY) - (minY ?? rect.minY))
    }

}
