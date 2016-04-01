//
//  APSpringButton.swift
//  Copyright © 2015 Appsidian. All rights reserved.
//

import UIKit

/// A UIButton subclass that renders a springy animation when tapped.
/// If the damping parameters are set to 1.0, this class may be used to provide subtle feedback to buttons with no elsasticity.
/// - parameter minimumScale: The minimum scale that the button may reach while pressed. Default 0.95
/// - parameter pressSpringDamping: The damping parameter for the spring animation used when the button is pressed. Default 0.4
/// - parameter releaseSpringDamping: The damping parameter for the spring animation used when the button is released. Default 0.35
/// - parameter pressSpringDuration: The duration of the spring animation used when the button is pressed. Default 0.4
/// - parameter releaseSpringDuration: The duration of the spring animation used when the button is reloeased. Default 0.5
public class APSpringButton: UIButton {
    
    public var minimumScale: CGFloat = 0.95
    public var pressSpringDamping: CGFloat = 0.4
    public var releaseSpringDamping: CGFloat = 0.35
    public var pressSpringDuration = 0.4
    public var releaseSpringDuration = 0.5
    
    public init() {
        super.init(frame: CGRectZero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        UIView.animateWithDuration(self.pressSpringDuration, delay: 0, usingSpringWithDamping: self.pressSpringDamping, initialSpringVelocity: 0, options: [.CurveLinear, .AllowUserInteraction], animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(self.minimumScale, self.minimumScale)
            }, completion: nil)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        UIView.animateWithDuration(self.releaseSpringDuration, delay: 0, usingSpringWithDamping: self.releaseSpringDamping, initialSpringVelocity: 0, options: [.CurveLinear, .AllowUserInteraction], animations: { () -> Void in
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInView(self)
        if !CGRectContainsPoint(self.bounds, location) {
            UIView.animateWithDuration(self.releaseSpringDuration, delay: 0, usingSpringWithDamping: self.releaseSpringDamping, initialSpringVelocity: 0, options: [.CurveLinear, .AllowUserInteraction], animations: { () -> Void in
                self.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        UIView.animateWithDuration(self.releaseSpringDuration, delay: 0, usingSpringWithDamping: self.releaseSpringDamping, initialSpringVelocity: 0, options: [.CurveLinear, .AllowUserInteraction], animations: { () -> Void in
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
}