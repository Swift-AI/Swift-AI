//
//  HandwritingViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/3/15.
//

import UIKit

class HandwritingViewController: UIViewController {
    
    var lastPoint = CGPointZero
    var swiped = false
    var drawing = false
    var timer = NSTimer()
    let brushWidth: CGFloat = 10.0
    
    let handwritingView = HandwritingView()
    
    override func loadView() {
        self.view = self.handwritingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handwritingView.clearButton.addTarget(self, action: "clearCanvas", forControlEvents: .TouchUpInside)
        self.handwritingView.infoButton.addTarget(self, action: "infoTapped", forControlEvents: .TouchUpInside)
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
        self.lastPoint = touch.locationInView(self.handwritingView.canvas)
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
            self.drawLine(fromPoint: self.lastPoint, toPoint: currentPoint)
        } else {
            self.drawLine(fromPoint: currentPoint, toPoint: currentPoint)
            self.swiped = true
        }
        self.lastPoint = currentPoint
        self.timer.invalidate()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first  else {
            return
        }
        if CGRectContainsPoint(self.handwritingView.canvas.frame, touch.locationInView(self.handwritingView)) {
            if !self.swiped {
                // Draw dot
                self.drawLine(fromPoint: self.lastPoint, toPoint: self.lastPoint)
            }
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "timerExpired:", userInfo: nil, repeats: false)
        self.drawing = false
        super.touchesEnded(touches, withEvent: event)
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
        infoView.effect = UIBlurEffect(style: .Dark)
        DrawerNavigationController.globalDrawerController().presentInfoView(infoView)
    }
    
    func timerExpired(sender: NSTimer) {
        self.clearCanvas()
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
