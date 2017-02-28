//
//  HandwritingView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/3/15.
//

import UIKit

class HandwritingView: UIView {
    
    let canvasContainer = UIView()
    let canvas = UIImageView()
    let snapshotBox = UIView()
    let outputContainer = UIView()
    let outputLabel = UILabel()
    let confidenceLabel = UILabel()
    let imageView = UIImageView()
    
    // Buttons
    let buttonContainer = UIView()
    let startPauseButton = APSpringButton()
    let clearButton = APSpringButton()
    let infoButton = APSpringButton()
    
    convenience init() {
        self.init(frame: CGRect.zero)
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
        self.addSubviews(self.canvasContainer, self.outputContainer, self.buttonContainer, self.imageView)
        self.canvasContainer.addSubviews(self.canvas, self.snapshotBox)
        self.outputContainer.addSubviews(self.outputLabel, self.confidenceLabel)
        self.buttonContainer.addSubviews(self.startPauseButton, self.clearButton, self.infoButton)
        
        // Style View
        self.backgroundColor = UIColor.swiftLightGray()
        
        // Style Subviews
        self.canvasContainer.backgroundColor = .white
        self.canvasContainer.layer.cornerRadius = 3
        self.canvasContainer.layer.shadowColor = UIColor.swiftMediumGray().cgColor
        self.canvasContainer.layer.shadowOpacity = 0.4
        self.canvasContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.canvas.backgroundColor = .clear
        
        self.snapshotBox.backgroundColor = UIColor.clear
        self.snapshotBox.layer.borderColor = UIColor.swiftGreen().cgColor
        self.snapshotBox.layer.borderWidth = 2
        self.snapshotBox.layer.cornerRadius = 6
        self.snapshotBox.alpha = 0
        
        self.outputContainer.backgroundColor = .white
        self.outputContainer.layer.cornerRadius = 4
        self.outputContainer.layer.shadowColor = UIColor.swiftMediumGray().cgColor
        self.outputContainer.layer.shadowOpacity = 0.3
        self.outputContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.outputLabel.textColor = .black
        self.outputLabel.textAlignment = .center
        self.outputLabel.font = UIFont.swiftFontOfSize(100)
        
        self.confidenceLabel.textColor = .black
        self.confidenceLabel.textAlignment = .right
        self.confidenceLabel.font = UIFont.swiftFontOfSize(15)
        
        self.imageView.backgroundColor = UIColor.white
        self.imageView.layer.cornerRadius = 4
        self.imageView.layer.shadowColor = UIColor.swiftMediumGray().cgColor
        self.imageView.layer.shadowOpacity = 0.3
        self.imageView.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.imageView.contentMode = .scaleAspectFit
        
        self.buttonContainer.backgroundColor = .white
        self.buttonContainer.layer.cornerRadius = 4
        self.buttonContainer.layer.shadowColor = UIColor.swiftMediumGray().cgColor
        self.buttonContainer.layer.shadowOpacity = 0.3
        self.buttonContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.startPauseButton.setImage(UIImage(named: "play"), for: UIControlState())
        self.startPauseButton.setImage(UIImage(named: "play_highlighted"), for: .highlighted)
        self.startPauseButton.backgroundColor = UIColor.swiftGreen()
        self.startPauseButton.layer.cornerRadius = 6
        self.startPauseButton.minimumScale = 0.92
        
        self.clearButton.setImage(UIImage(named: "reset"), for: UIControlState())
        self.clearButton.setImage(UIImage(named: "reset_highlighted"), for: .highlighted)
        self.clearButton.backgroundColor = UIColor.swiftLightOrange()
        self.clearButton.layer.cornerRadius = 6
        self.clearButton.minimumScale = 0.92
        
        self.infoButton.setImage(UIImage(named: "info"), for: UIControlState())
        self.infoButton.setImage(UIImage(named: "info_highlighted"), for: .highlighted)
        self.infoButton.backgroundColor = UIColor.swiftDarkOrange()
        self.infoButton.layer.cornerRadius = 6
        self.infoButton.minimumScale = 0.92
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        canvasContainer.addConstraints(
            Constraint.llrr.of(self, offset: 10),
            Constraint.tt.of(self, offset: 15),
            Constraint.hw.of(self, offset: -20))
        
//        self.canvasContainer.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 10),
//            Constraint.rr : (of: self, offset: -10),
//            Constraint.tt : (of: self, offset: 15),
//            Constraint.hw : (of: self, offset: -20)])
        
        self.canvas.fillSuperview()
        
        imageView.addConstraints(
            Constraint.ll.of(self, offset: 10),
            Constraint.rcx.of(self, offset: -7),
            Constraint.tb.of(canvasContainer, offset: 15),
            Constraint.bt.of(buttonContainer, offset: -15))
        
//        self.imageView.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 10),
//            Constraint.rcx : (of: self, offset: -7),
//            Constraint.tb : (of: self.canvasContainer, offset: 15),
//            Constraint.bt : (of: self.buttonContainer, offset: -15)])
        
        outputContainer.addConstraints(
            Constraint.lcx.of(self, offset: 7),
            Constraint.rr.of(self, offset: -10),
            Constraint.tb.of(canvasContainer, offset: 15),
            Constraint.bt.of(buttonContainer, offset: -15))
        
//        self.outputContainer.constrainUsing(constraints: [
//            Constraint.lcx : (of: self, offset: 7),
//            Constraint.rr : (of: self, offset: -10),
//            Constraint.tb : (of: self.canvasContainer, offset: 15),
//            Constraint.bt : (of: self.buttonContainer, offset: -15)])
        
        self.outputLabel.centerInSuperview()
        
        confidenceLabel.addConstraints(
            Constraint.rr.of(outputContainer),
            Constraint.bb.of(outputContainer))
        
//        self.confidenceLabel.constrainUsing(constraints: [
//            Constraint.rr : (of: self.outputContainer, offset: 0),
//            Constraint.bb : (of: self.outputContainer, offset: 0)])
        
        buttonContainer.addConstraints(
            Constraint.llrr.of(canvasContainer),
            Constraint.bb.of(self, offset: -15),
            Constraint.hw.of(buttonContainer, multiplier: 0.18))
        
//        self.buttonContainer.constrainUsing(constraints: [
//            Constraint.ll : (of: self.canvasContainer, multiplier: 1, offset: 0),
//            Constraint.rr : (of: self.canvasContainer, multiplier: 1, offset: 0),
//            Constraint.bb : (of: self, multiplier: 1, offset: -15),
//            Constraint.hw : (of: self.buttonContainer, multiplier: 0.18, offset: 0)])
        
        startPauseButton.addConstraints(
            Constraint.ll.of(buttonContainer, offset: 5),
            Constraint.w.of(clearButton),
            Constraint.ttbb.of(buttonContainer, offset: 5))
        
//        self.startPauseButton.constrainUsing(constraints: [
//            Constraint.ll : (of: self.buttonContainer, offset: 5),
//            Constraint.w : (of: self.clearButton, offset: 0),
//            Constraint.tt : (of: self.buttonContainer, offset: 5),
//            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        clearButton.addConstraints(
            Constraint.lr.of(startPauseButton, offset: 5),
            Constraint.w.of(infoButton),
            Constraint.ttbb.of(buttonContainer, offset: 5))
        
//        self.clearButton.constrainUsing(constraints: [
//            Constraint.lr : (of: self.startPauseButton, offset: 5),
//            Constraint.w : (of: self.infoButton, offset: 0),
//            Constraint.tt : (of: self.buttonContainer, offset: 5),
//            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        infoButton.addConstraints(
            Constraint.lr.of(clearButton, offset: 5),
            Constraint.rr.of(buttonContainer, offset: -5),
            Constraint.ttbb.of(buttonContainer, offset: 5))
        
//        self.infoButton.constrainUsing(constraints: [
//            Constraint.lr : (of: self.clearButton, offset: 5),
//            Constraint.rr : (of: self.buttonContainer, offset: -5),
//            Constraint.tt : (of: self.buttonContainer, offset: 5),
//            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        super.updateConstraints()
    }
    
    // Note: Shadow paths defined here where views have frames
    override func layoutSubviews() {
        super.layoutSubviews()
        self.canvasContainer.layer.shadowPath = UIBezierPath(roundedRect: self.canvasContainer.bounds, cornerRadius: self.canvasContainer.layer.cornerRadius).cgPath
        self.outputContainer.layer.shadowPath = UIBezierPath(roundedRect: self.outputContainer.bounds, cornerRadius: self.outputContainer.layer.cornerRadius).cgPath
        self.imageView.layer.shadowPath = UIBezierPath(roundedRect: self.imageView.bounds, cornerRadius: self.imageView.layer.cornerRadius).cgPath
        self.buttonContainer.layer.shadowPath = UIBezierPath(roundedRect: self.buttonContainer.bounds, cornerRadius: self.buttonContainer.layer.cornerRadius).cgPath
    }
}
