//
//  NavigationBar.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/25/15.
//

import UIKit

class NavigationBar: UIView {
    
    let titleLabel = UILabel()
    let hamburgerButton = UIButton()
    let gradient = CAGradientLayer()
    
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
        self.addSubviews(self.titleLabel, self.hamburgerButton)
        self.layer.insertSublayer(self.gradient, at: 0)
        
        // Style View
        
        
        // Style Subviews
        self.titleLabel.text = "Swift AI"
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.swiftFontOfSize(20)
        
        self.hamburgerButton.setImage(UIImage(named: "hamburger"), for: UIControlState())
        self.hamburgerButton.setImage(UIImage(named: "hamburger_highlighted"), for: .highlighted)
        self.hamburgerButton.imageEdgeInsets = UIEdgeInsets(top: 12.5, left: 10, bottom: 12.5, right: 30)
        
        self.gradient.colors = [UIColor.swiftDarkOrange().cgColor, UIColor.swiftLightOrange().cgColor]
        self.gradient.startPoint = CGPoint.zero
        self.gradient.endPoint = CGPoint(x: 1, y: 0)
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        titleLabel.addConstraints(
            Constraint.cxcx.of(self),
            Constraint.cycy.of(self, offset: 7)) // Centered in area below status bar
        
//        self.titleLabel.constrainUsing(constraints: [
//            Constraint.cxcx : (of: self, offset: 0),
//            Constraint.cycy : (of: self, offset: 7)])
        
        hamburgerButton.addConstraints(
            Constraint.ll.of(self),
            Constraint.w.of(80),
            Constraint.cycy.of(self, offset: 7), // Centered in area below status bar
            Constraint.h.of(50))
        
//        self.hamburgerButton.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 0),
//            Constraint.w : (of: nil, offset: 80),
//            Constraint.cycy : (of: self, offset: 7),
//            Constraint.h : (of: nil, offset: 50)])
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.frame
    }
}
