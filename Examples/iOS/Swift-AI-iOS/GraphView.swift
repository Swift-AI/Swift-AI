//
//  MainView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/24/15.
//

import UIKit
import APKit

class GraphView: UIView {
    
    let graph = UIImageView(image: UIImage(named: "graph"))
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
    let functionButton = UIButton()
    let resetButton = UIButton()
    
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
        self.addSubviews([self.xAxis, self.yAxis, self.negXLabel, self.posXLabel, self.negYLabel, self.posYLabel,
            self.functionLabel, self.slider, self.startPauseButton, self.functionButton, self.resetButton])
        
        // Style View
        self.backgroundColor = .white
        
        // Style Subviews
        self.xAxis.backgroundColor = .blackColor()
        self.yAxis.backgroundColor = .blackColor()
        
        self.negXLabel.text = "-5"
        self.posXLabel.text = "5"
        self.negYLabel.text = "-1"
        self.posYLabel.text = "1"
        
        self.functionLabel.textColor = .red
        
        self.slider.minimumValue = 0.5
        self.slider.maximumValue = 2.5
        self.slider.value = 1.5
    
        self.startPauseButton.setTitle("Start", forState: .Normal)
        self.startPauseButton.setTitleColor(UIColor.swiftLightOrange(), forState: .Highlighted)
        self.startPauseButton.backgroundColor = UIColor.swiftGreen()
        
        self.functionButton.setTitle("Function", forState: .Normal)
        self.functionButton.setTitleColor(UIColor.swiftDarkOrange(), forState: .Highlighted)
        self.functionButton.backgroundColor = UIColor.swiftLightOrange()
        
        self.resetButton.setTitle("Reset", forState: .Normal)
        self.resetButton.setTitleColor(UIColor.swiftLightOrange(), forState: .Highlighted)
        self.resetButton.backgroundColor = UIColor.swiftDarkOrange()
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
            Constraint.lr : (of: self.yAxis, offset: 4),
            Constraint.tt : (of: self.yAxis, offset: 0)])
        
        self.negYLabel.constrainUsing(constraints: [
            Constraint.lr : (of: self.yAxis, offset: 4),
            Constraint.bb : (of: self.yAxis, offset: 0)])
        
        self.functionLabel.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.bt : (of: self.slider, offset: -15)])
        
        self.slider.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 40),
            Constraint.rr : (of: self, offset: -40),
            Constraint.bt : (of: self.startPauseButton, offset: -20)])
        
        self.startPauseButton.constrainUsing(constraints: [
            Constraint.ll : (of: self, multiplier: 1, offset: 0),
            Constraint.w : (of: self.resetButton, multiplier: 1, offset: 0),
            Constraint.bb : (of: self, multiplier: 1, offset: 0),
            Constraint.hw : (of: self.startPauseButton, multiplier: 0.6, offset: 0)])
        
        self.functionButton.constrainUsing(constraints: [
            Constraint.lr : (of: self.startPauseButton, multiplier: 1, offset: 0),
            Constraint.w : (of: self.resetButton, multiplier: 1, offset: 0),
            Constraint.bb : (of: self, multiplier: 1, offset: 0),
            Constraint.hw : (of: self.functionButton, multiplier: 0.6, offset: 0)])
        
        self.resetButton.constrainUsing(constraints: [
            Constraint.lr : (of: self.functionButton, multiplier: 1, offset: 0),
            Constraint.rr : (of: self, multiplier: 1, offset: 0),
            Constraint.bb : (of: self, multiplier: 1, offset: 0),
            Constraint.hw : (of: self.resetButton, multiplier: 0.6, offset: 0)])
        
        
        super.updateConstraints()
    }

}
