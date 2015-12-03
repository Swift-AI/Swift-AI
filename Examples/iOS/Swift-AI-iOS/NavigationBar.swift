//
//  NavigationBar.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/25/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import UIKit
import APKit

class NavigationBar: UIView {
    
    let titleLabel = UILabel()
    let hamburgerButton = UIButton()
    let gradient = CAGradientLayer()
    
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
        self.addSubviews([self.titleLabel, self.hamburgerButton])
        self.layer.insertSublayer(self.gradient, atIndex: 0)
        
        // Style View
        
        
        // Style Subviews
        self.titleLabel.text = "Swift AI"
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.swiftFontOfSize(20)
        
        self.hamburgerButton.setImage(UIImage(named: "hamburger"), forState: .Normal)
        self.hamburgerButton.setImage(UIImage(named: "hamburger_highlighted"), forState: .Highlighted)
        self.hamburgerButton.imageEdgeInsets = UIEdgeInsets(top: 12.5, left: 10, bottom: 12.5, right: 30)
        
        self.gradient.colors = [UIColor.swiftDarkOrange().CGColor, UIColor.swiftLightOrange().CGColor]
        self.gradient.startPoint = CGPointZero
        self.gradient.endPoint = CGPointMake(1, 0)
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        self.titleLabel.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.cycy : (of: self, offset: 7)]) // Centers the y in area below status bar
        
        self.hamburgerButton.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 0),
            Constraint.w : (of: nil, offset: 80),
            Constraint.cycy : (of: self, offset: 7),
            Constraint.h : (of: nil, offset: 50)])
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.frame
    }
}
