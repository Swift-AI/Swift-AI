//
//  MainView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/24/15.
//

import UIKit
import APKit

class GraphView: UIView {
    
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
        self.addSubviews([self.functionLabel, self.slider, self.startPauseButton, self.functionButton, self.resetButton])
        
        // Style View
        self.backgroundColor = .white
        
        // Style Subviews
        self.functionLabel.textColor = .red
        
        self.slider.minimumValue = 0.5
        self.slider.maximumValue = 2.5
        self.slider.value = 1.5
    
        self.startPauseButton.setTitle("Start", forState: .Normal)
        self.startPauseButton.backgroundColor = UIColor.swiftDarkOrange()
        
        self.functionButton.setTitle("Function", forState: .Normal)
        self.functionButton.backgroundColor = UIColor.swiftMediumOrange()
        
        self.resetButton.setTitle("Reset", forState: .Normal)
        self.resetButton.backgroundColor = UIColor.swiftLightOrange()
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        
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
