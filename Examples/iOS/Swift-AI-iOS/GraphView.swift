//
//  GraphView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/24/15.
//

import UIKit
import APKit

class GraphView: UIView {
    
    let xAxis = UIView()
    let yAxis = UIView()
    let negXLabel = UILabel()
    let posXLabel = UILabel()
    let negYLabel = UILabel()
    let posYLabel = UILabel()
    let slider = UISlider()
    let functionLabel = UILabel()
    let errorLabel = UILabel()
    let startPauseButton = UIButton()
    let resetButton = UIButton()
    let infoButton = UIButton()
    
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
        self.insertSubview(self.xAxis, atIndex: 0)
        self.insertSubview(self.yAxis, atIndex: 1)
        self.addSubviews([self.negXLabel, self.posXLabel, self.negYLabel, self.posYLabel,
            self.functionLabel, self.slider, self.startPauseButton, self.infoButton, self.resetButton])
        
        // Style View
        self.backgroundColor = .whiteColor()
        
        // Style Subviews
        self.xAxis.backgroundColor = .blackColor()
        self.yAxis.backgroundColor = .blackColor()
        
        self.negXLabel.text = "-5"
        self.posXLabel.text = "5"
        self.negYLabel.text = "-1"
        self.posYLabel.text = "1"
        
        self.functionLabel.textColor = UIColor.swiftGreen()
        self.functionLabel.font = UIFont.swiftFontOfSize(18)
        
        self.slider.minimumValue = 0.5
        self.slider.maximumValue = 3.0
        self.slider.value = 1.5
        self.slider.tintColor = UIColor.swiftGreen()
    
        self.startPauseButton.setTitle("Start", forState: .Normal)
        self.startPauseButton.setTitleColor(UIColor.swiftLightGray(), forState: .Highlighted)
        self.startPauseButton.titleLabel?.font = UIFont.swiftFontOfSize(18)
        self.startPauseButton.backgroundColor = UIColor.swiftGreen()
        
        self.infoButton.setTitle("Info", forState: .Normal)
        self.infoButton.setTitleColor(UIColor.swiftLightOrange(), forState: .Highlighted)
        self.infoButton.titleLabel?.font = UIFont.swiftFontOfSize(18)
        self.infoButton.backgroundColor = UIColor.swiftDarkOrange()
        
        self.resetButton.setTitle("Reset", forState: .Normal)
        self.resetButton.setTitleColor(UIColor.swiftDarkOrange(), forState: .Highlighted)
        self.resetButton.titleLabel?.font = UIFont.swiftFontOfSize(18)
        self.resetButton.backgroundColor = UIColor.swiftLightOrange()
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        self.xAxis.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 0),
            Constraint.rr : (of: self, offset: 0),
            Constraint.cycy : (of: self.yAxis, offset: 0),
            Constraint.h : (of: nil, offset: 2)])
        
        self.yAxis.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.w : (of: nil, offset: 2),
            Constraint.tt : (of: self, offset: 15),
            Constraint.hw : (of: self.xAxis, offset: -30)])
        
        self.negXLabel.constrainUsing(constraints: [
            Constraint.ll : (of: self.xAxis, offset: 2),
            Constraint.tb : (of: self.xAxis, offset: 0)])
        
        self.posXLabel.constrainUsing(constraints: [
            Constraint.rr : (of: self.xAxis, offset: -2),
            Constraint.tb : (of: self.xAxis, offset: 0)])
        
        self.posYLabel.constrainUsing(constraints: [
            Constraint.lr : (of: self.yAxis, offset: 6),
            Constraint.tt : (of: self.yAxis, offset: 0)])
        
        self.negYLabel.constrainUsing(constraints: [
            Constraint.lr : (of: self.yAxis, offset: 6),
            Constraint.bb : (of: self.yAxis, offset: 0)])
        
        self.functionLabel.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.bt : (of: self.slider, offset: -15)])
        
        self.slider.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 40),
            Constraint.rr : (of: self, offset: -40),
            Constraint.bt : (of: self.startPauseButton, offset: -20)])
        
        self.startPauseButton.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 0),
            Constraint.w : (of: self.resetButton, offset: 0),
            Constraint.bb : (of: self, offset: 0),
            Constraint.h : (of: nil, offset: 64)])
        
        self.resetButton.constrainUsing(constraints: [
            Constraint.lr : (of: self.startPauseButton, offset: 0),
            Constraint.w : (of: self.infoButton, offset: 0),
            Constraint.bb : (of: self, offset: 0),
            Constraint.h : (of: nil, offset: 64)])
        
        self.infoButton.constrainUsing(constraints: [
            Constraint.lr : (of: self.resetButton, offset: 0),
            Constraint.rr : (of: self, offset: 0),
            Constraint.bb : (of: self, offset: 0),
            Constraint.h : (of: nil, offset: 64)])
        
        
        super.updateConstraints()
    }

}
