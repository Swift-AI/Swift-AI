//
//  GraphView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/24/15.
//

import UIKit
import APKit

class GraphView: UIView {
    
    // Graph
    let graphContainer = UIView()
    let xAxis = UIView()
    let yAxis = UIView()
    let negXLabel = UILabel()
    let posXLabel = UILabel()
    let negYLabel = UILabel()
    let posYLabel = UILabel()
    // Slider controls
    let sliderContainer = UIView()
//    let functionLabel = UILabel()
    let functionLabel = APSpringButton()
    let slider = UISlider()
    // Buttons
    let buttonContainer = UIView()
    let startPauseButton = APSpringButton()
    let resetButton = APSpringButton()
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
        self.addSubviews([self.graphContainer, self.sliderContainer, self.buttonContainer])
        self.graphContainer.insertSubview(self.xAxis, atIndex: 0)
        self.graphContainer.insertSubview(self.yAxis, atIndex: 1)
        self.graphContainer.addSubviews([self.negXLabel, self.posXLabel, self.negYLabel, self.posYLabel])
        self.sliderContainer.addSubviews([self.functionLabel, self.slider])
        self.buttonContainer.addSubviews([self.startPauseButton, self.infoButton, self.resetButton])
        
        // Style View
        self.backgroundColor = UIColor.swiftLightGray()
        
        // Style Subviews
        self.graphContainer.backgroundColor = .whiteColor()
        self.graphContainer.layer.cornerRadius = 4
        self.graphContainer.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.graphContainer.layer.shadowOpacity = 0.4
        self.graphContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        self.xAxis.backgroundColor = .swiftMediumGray()
        self.yAxis.backgroundColor = .swiftMediumGray()
        
        self.negXLabel.text = "-5"
        self.posXLabel.text = "5"
        self.negYLabel.text = "-1"
        self.posYLabel.text = "1"
        
        self.sliderContainer.backgroundColor = .whiteColor()
        self.sliderContainer.layer.cornerRadius = 4
        self.sliderContainer.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.sliderContainer.layer.shadowOpacity = 0.4
        self.sliderContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        self.functionLabel.titleLabel?.font = UIFont.swiftFontOfSize(18)
        self.functionLabel.setTitleColor(UIColor.swiftGreen(), forState: .Normal)
        self.functionLabel.backgroundColor = UIColor.clearColor()
//        self.functionLabel.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        self.functionLabel.layer.cornerRadius = 6
        self.functionLabel.minimumScale = 0.92
        
        self.slider.minimumValue = 0.5
        self.slider.maximumValue = 3.0
        self.slider.value = 1.5
        self.slider.tintColor = UIColor.swiftGreen()
    
        self.buttonContainer.backgroundColor = .whiteColor()
        self.buttonContainer.layer.cornerRadius = 4
        self.buttonContainer.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.buttonContainer.layer.shadowOpacity = 0.4
        self.buttonContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        self.startPauseButton.setImage(UIImage(named: "play"), forState: .Normal)
        self.startPauseButton.setImage(UIImage(named: "play_highlighted"), forState: .Highlighted)
        self.startPauseButton.backgroundColor = UIColor.swiftGreen()
        self.startPauseButton.layer.cornerRadius = 6
        self.startPauseButton.minimumScale = 0.92
        
        self.resetButton.setImage(UIImage(named: "reset"), forState: .Normal)
        self.resetButton.setImage(UIImage(named: "reset_highlighted"), forState: .Highlighted)
        self.resetButton.backgroundColor = UIColor.swiftLightOrange()
        self.resetButton.layer.cornerRadius = 6
        self.resetButton.minimumScale = 0.92
        
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
        
        // Graph
        self.graphContainer.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 10),
            Constraint.rr : (of: self, offset: -10),
            Constraint.tt : (of: self, offset: 15),
            Constraint.hw : (of: self, offset: -20)])
        
        self.xAxis.constrainUsing(constraints: [
            Constraint.ll : (of: self.graphContainer, offset: 5),
            Constraint.rr : (of: self.graphContainer, offset: -5),
            Constraint.cycy : (of: self.yAxis, offset: 0),
            Constraint.h : (of: nil, offset: 1.5)])
        
        self.yAxis.constrainUsing(constraints: [
            Constraint.cxcx : (of: self.graphContainer, offset: 0),
            Constraint.w : (of: nil, offset: 1.5),
            Constraint.tt : (of: self.graphContainer, offset: 5),
            Constraint.bb : (of: self.graphContainer, offset: -5)])
        
        self.negXLabel.constrainUsing(constraints: [
            Constraint.ll : (of: self.xAxis, offset: 2),
            Constraint.tb : (of: self.xAxis, offset: 2)])
        
        self.posXLabel.constrainUsing(constraints: [
            Constraint.rr : (of: self.xAxis, offset: -2),
            Constraint.tb : (of: self.xAxis, offset: 2)])
        
        self.posYLabel.constrainUsing(constraints: [
            Constraint.lr : (of: self.yAxis, offset: 6),
            Constraint.tt : (of: self.yAxis, offset: 0)])
        
        self.negYLabel.constrainUsing(constraints: [
            Constraint.lr : (of: self.yAxis, offset: 6),
            Constraint.bb : (of: self.yAxis, offset: 0)])
        
        // Slider
        
        self.sliderContainer.constrainUsing(constraints: [
            Constraint.ll : (of: self.graphContainer, offset: 0),
            Constraint.rr : (of: self.graphContainer, offset: 0),
            Constraint.tb : (of: self.graphContainer, offset: 20),
            Constraint.bt : (of: self.buttonContainer, offset: -20)])
        
        self.functionLabel.constrainUsing(constraints: [
            Constraint.cxcx : (of: self.sliderContainer, offset: 0),
            Constraint.w : (of: nil, offset: self.functionLabel.intrinsicContentSize().width + 30),
            Constraint.bcy : (of: self.sliderContainer, offset: -7)])

        self.slider.constrainUsing(constraints: [
            Constraint.ll : (of: self.sliderContainer, offset: 20),
            Constraint.rr : (of: self.sliderContainer, offset: -20),
            Constraint.tcy : (of: self.sliderContainer, offset: 7)])
        
        // Buttons
        
        self.buttonContainer.constrainUsing(constraints: [
            Constraint.ll : (of: self.graphContainer, multiplier: 1, offset: 0),
            Constraint.rr : (of: self.graphContainer, multiplier: 1, offset: 0),
            Constraint.bb : (of: self, multiplier: 1, offset: -15),
            Constraint.hw : (of: self.buttonContainer, multiplier: 0.18, offset: 0)])
        
        self.startPauseButton.constrainUsing(constraints: [
            Constraint.ll : (of: self.buttonContainer, offset: 5),
            Constraint.w : (of: self.resetButton, offset: 0),
            Constraint.tt : (of: self.buttonContainer, offset: 5),
            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        self.resetButton.constrainUsing(constraints: [
            Constraint.lr : (of: self.startPauseButton, offset: 5),
            Constraint.w : (of: self.infoButton, offset: 0),
            Constraint.tt : (of: self.buttonContainer, offset: 5),
            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        self.infoButton.constrainUsing(constraints: [
            Constraint.lr : (of: self.resetButton, offset: 5),
            Constraint.rr : (of: self.buttonContainer, offset: -5),
            Constraint.tt : (of: self.buttonContainer, offset: 5),
            Constraint.bb : (of: self.buttonContainer, offset: -5)])
        
        
        super.updateConstraints()
    }

}
