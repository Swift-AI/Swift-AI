//
//  HandwritingLearnView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/18/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import UIKit
import APKit

class HandwritingLearnView: UIView {
    
    let textField = UITextField()
    let canvasContainer = UIView()
    let canvas = UIImageView()
    
    // Buttons
    let buttonContainer = UIView()
    let startPauseButton = APSpringButton()
    let clearButton = APSpringButton()
    let infoButton = APSpringButton()
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        // Add Subviews
        self.addSubviews([self.textField, self.canvasContainer, self.buttonContainer])
        self.canvasContainer.addSubview(self.canvas)
        self.buttonContainer.addSubviews([self.startPauseButton, self.clearButton, self.infoButton])
        
        // Style View
        self.backgroundColor = UIColor.swiftLightGray()
        
        // Style Subviews
        self.textField.backgroundColor = .whiteColor()
        self.textField.textAlignment = .Center
        self.textField.font = UIFont.swiftFontOfSize(60)
        self.textField.keyboardType = .NumberPad
        self.textField.layer.cornerRadius = 3
        self.textField.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.textField.layer.shadowOpacity = 0.4
        self.textField.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.canvasContainer.backgroundColor = .whiteColor()
        self.canvasContainer.layer.cornerRadius = 3
        self.canvasContainer.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.canvasContainer.layer.shadowOpacity = 0.4
        self.canvasContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.canvas.backgroundColor = .clearColor()
        
        self.buttonContainer.backgroundColor = .whiteColor()
        self.buttonContainer.layer.cornerRadius = 4
        self.buttonContainer.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.buttonContainer.layer.shadowOpacity = 0.3
        self.buttonContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.startPauseButton.setImage(UIImage(named: "play"), forState: .Normal)
        self.startPauseButton.setImage(UIImage(named: "play_highlighted"), forState: .Highlighted)
        self.startPauseButton.backgroundColor = UIColor.swiftGreen()
        self.startPauseButton.layer.cornerRadius = 6
        self.startPauseButton.minimumScale = 0.92
        
        self.clearButton.setImage(UIImage(named: "reset"), forState: .Normal)
        self.clearButton.setImage(UIImage(named: "reset_highlighted"), forState: .Highlighted)
        self.clearButton.backgroundColor = UIColor.swiftLightOrange()
        self.clearButton.layer.cornerRadius = 6
        self.clearButton.minimumScale = 0.92
        
        self.infoButton.setImage(UIImage(named: "info"), forState: .Normal)
        self.infoButton.setImage(UIImage(named: "info_highlighted"), forState: .Highlighted)
        self.infoButton.backgroundColor = UIColor.swiftDarkOrange()
        self.infoButton.layer.cornerRadius = 6
        self.infoButton.minimumScale = 0.92
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        self.textField.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.w : (of: nil, offset: 60),
            Constraint.tt : (of: self, offset: 15),
            Constraint.h : (of: nil, offset: 60)])
        
        self.canvasContainer.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 10),
            Constraint.rr : (of: self, offset: -10),
            Constraint.tb : (of: self.textField, offset: 10),
            Constraint.hw : (of: self, offset: -20)])
        
        self.canvas.fillSuperview()
        
        self.buttonContainer.constrainUsing(constraints: [
            Constraint.ll : (of: self.canvasContainer, multiplier: 1, offset: 0),
            Constraint.rr : (of: self.canvasContainer, multiplier: 1, offset: 0),
            Constraint.bb : (of: self, multiplier: 1, offset: -15),
            Constraint.hw : (of: self.buttonContainer, multiplier: 0.18, offset: 0)])
        
        self.startPauseButton.constrainUsing(constraints: [
            Constraint.ll : (of: self.buttonContainer, offset: 5),
            Constraint.w : (of: self.clearButton, offset: 0),
            Constraint.tt : (of: self.buttonContainer, offset: 5),
            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        self.clearButton.constrainUsing(constraints: [
            Constraint.lr : (of: self.startPauseButton, offset: 5),
            Constraint.w : (of: self.infoButton, offset: 0),
            Constraint.tt : (of: self.buttonContainer, offset: 5),
            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        self.infoButton.constrainUsing(constraints: [
            Constraint.lr : (of: self.clearButton, offset: 5),
            Constraint.rr : (of: self.buttonContainer, offset: -5),
            Constraint.tt : (of: self.buttonContainer, offset: 5),
            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        super.updateConstraints()
    }
    
    // Note: Shadow paths defined here where views have frames
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.layer.shadowPath = UIBezierPath(roundedRect: self.textField.bounds, cornerRadius: self.textField.layer.cornerRadius).CGPath
        self.canvasContainer.layer.shadowPath = UIBezierPath(roundedRect: self.canvasContainer.bounds, cornerRadius: self.canvasContainer.layer.cornerRadius).CGPath
        self.buttonContainer.layer.shadowPath = UIBezierPath(roundedRect: self.buttonContainer.bounds, cornerRadius: self.buttonContainer.layer.cornerRadius).CGPath
    }
}
