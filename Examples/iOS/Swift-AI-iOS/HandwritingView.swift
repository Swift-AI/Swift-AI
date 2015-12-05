//
//  HandwritingView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/3/15.
//

import UIKit
import APKit

class HandwritingView: UIView {
    
    let tempLabel = UILabel()
    
    let canvasContainer = UIView()
    let canvas = UIImageView()
    
    let outputContainer = UIView()
    let outputLabel = UILabel()
    
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
        self.addSubviews([self.canvasContainer, self.outputContainer, self.buttonContainer])
        self.canvasContainer.addSubview(self.canvas)
        self.outputContainer.addSubview(self.outputLabel)
        self.buttonContainer.addSubviews([self.startPauseButton, self.clearButton, self.infoButton])
        
        // Style View
        self.backgroundColor = UIColor.swiftLightGray()
        
        // Style Subviews
        self.canvasContainer.backgroundColor = .whiteColor()
        self.canvasContainer.layer.cornerRadius = 3
        self.canvasContainer.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.canvasContainer.layer.shadowOpacity = 0.4
        self.canvasContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.canvas.backgroundColor = .clearColor()
        
        self.outputContainer.backgroundColor = .whiteColor()
        self.outputContainer.layer.cornerRadius = 4
        self.outputContainer.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.outputContainer.layer.shadowOpacity = 0.3
        self.outputContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.outputLabel.text = "6"
        self.outputLabel.textColor = .blackColor()
        self.outputLabel.textAlignment = .Center
        self.outputLabel.font = UIFont.swiftFontOfSize(80)
        
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
        
        self.tempLabel.text = "Handwriting recognition: under construction"
        self.tempLabel.textColor = .blackColor()
        self.tempLabel.font = UIFont.swiftFontOfSize(14)
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        self.canvasContainer.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 10),
            Constraint.rr : (of: self, offset: -10),
            Constraint.tt : (of: self, offset: 15),
            Constraint.hw : (of: self, offset: -20)])
        
        self.canvas.fillSuperview()
        
        self.outputContainer.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.w : (of: nil, offset: 200),
            Constraint.tb : (of: self.canvasContainer, offset: 15),
            Constraint.bt : (of: self.buttonContainer, offset: -15)])
        
        self.outputLabel.centerInSuperview()
        
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
        self.canvasContainer.layer.shadowPath = UIBezierPath(roundedRect: self.canvasContainer.bounds, cornerRadius: self.canvasContainer.layer.cornerRadius).CGPath
        self.outputContainer.layer.shadowPath = UIBezierPath(roundedRect: self.outputContainer.bounds, cornerRadius: self.outputContainer.layer.cornerRadius).CGPath
        self.buttonContainer.layer.shadowPath = UIBezierPath(roundedRect: self.buttonContainer.bounds, cornerRadius: self.buttonContainer.layer.cornerRadius).CGPath
    }
}
