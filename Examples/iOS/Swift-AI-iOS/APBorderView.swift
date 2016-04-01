//
//  APBorderView.swift
//  Copyright © 2015 Appsidian. All rights reserved.
//

import UIKit

public enum BorderPosition {
    case Top
    case Bottom
    case TopBottom
}

/** 
    A subclass of UIView that provides the ability to add two optional borders.
    One to the top, one to the bottom, or both.

    :param: border The position of the border(s)
    :param: color The color of the border(s)
*/
public class APBorderView: UIView {
    
    // Data
    var position: BorderPosition!
    var borderColor: UIColor!
    var borderWeight: CGFloat!
    
    // Views
    let topBorder = UIView()
    let bottomBorder = UIView()
    
    convenience public init(border: BorderPosition, color: UIColor, weight: CGFloat) {
        self.init(frame: CGRectZero)
        self.position = border
        self.borderColor = color
        self.borderWeight = weight
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setNeedsUpdateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        
        // Add Subviews
        switch self.position! {
        case .Top:
            self.addSubview(self.topBorder)
        case .Bottom:
            self.addSubview(self.bottomBorder)
        case .TopBottom:
            self.addSubview(self.topBorder)
            self.addSubview(self.bottomBorder)
        }
        
        // Style Subviews
        self.topBorder.backgroundColor = self.borderColor
        self.bottomBorder.backgroundColor = self.borderColor
        
    }
    
    override public func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        switch self.position! {
        case .Top:
            topBorder.addConstraints(
                Constraint.llrr.of(self),
                Constraint.tt.of(self),
                Constraint.h.of(borderWeight))
            
//            self.topBorder.constrainUsing(constraints: [
//                Constraint.LeftToLeft : (of: self, offset: 0),
//                Constraint.RightToRight : (of: self, offset: 0),
//                Constraint.TopToTop : (of: self, offset: 0),
//                Constraint.Height : (of: nil, offset: self.borderWeight)])

        case .Bottom:
            bottomBorder.addConstraints(
                Constraint.llrr.of(self),
                Constraint.bb.of(self),
                Constraint.h.of(borderWeight))
            
//            self.bottomBorder.constrainUsing(constraints: [
//                Constraint.LeftToLeft : (of: self, offset: 0),
//                Constraint.RightToRight : (of: self, offset: 0),
//                Constraint.BottomToBottom : (of: self, offset: 0),
//                Constraint.Height : (of: nil, offset: self.borderWeight)])

        case .TopBottom:
            topBorder.addConstraints(
                Constraint.llrr.of(self),
                Constraint.tt.of(self),
                Constraint.h.of(borderWeight))
            
//            self.topBorder.constrainUsing(constraints: [
//                Constraint.LeftToLeft : (of: self, offset: 0),
//                Constraint.RightToRight : (of: self, offset: 0),
//                Constraint.TopToTop : (of: self, offset: 0),
//                Constraint.Height : (of: nil, offset: self.borderWeight)])
            
            bottomBorder.addConstraints(
                Constraint.llrr.of(self),
                Constraint.bb.of(self),
                Constraint.h.of(borderWeight))
            
//            self.bottomBorder.constrainUsing(constraints: [
//                Constraint.LeftToLeft : (of: self, offset: 0),
//                Constraint.RightToRight : (of: self, offset: 0),
//                Constraint.BottomToBottom : (of: self, offset: 0),
//                Constraint.Height : (of: nil, offset: self.borderWeight)])
            
        }
        
        super.updateConstraints()
    }
    
    public func hideBorders() {
        self.topBorder.alpha = 0
        self.bottomBorder.alpha = 0
    }
    
    public func showBorders() {
        self.topBorder.alpha = 1
        self.bottomBorder.alpha = 1
    }
    
    public func hideBorder(border: BorderPosition) {
        switch border {
        case .Top:
            self.topBorder.alpha = 0
        case .Bottom:
            self.bottomBorder.alpha = 0
        case .TopBottom:
            self.topBorder.alpha = 0
            self.bottomBorder.alpha = 0
        }
    }
    
    public func showBorder(border: BorderPosition) {
        switch border {
        case .Top:
            self.topBorder.alpha = 1
        case .Bottom:
            self.bottomBorder.alpha = 1
        case .TopBottom:
            self.topBorder.alpha = 1
            self.bottomBorder.alpha = 1
        }
    }
}
