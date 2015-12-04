//
//  HandwritingView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/3/15.
//

import UIKit
import APKit

class HandwritingView: UIView {
    
    let canvasContainer = UIView()
    let canvas = UIImageView()
    let clearButton = APSpringButton()
    
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
        self.addSubviews([self.canvasContainer, self.clearButton])
        self.canvasContainer.addSubview(self.canvas)
        
        // Style View
        self.backgroundColor = UIColor.swiftLightGray()
        
        // Style Subviews
        self.canvasContainer.backgroundColor = .whiteColor()
        self.canvasContainer.layer.cornerRadius = 4
        self.canvasContainer.layer.shadowColor = UIColor.swiftMediumGray().CGColor
        self.canvasContainer.layer.shadowOpacity = 0.4
        self.canvasContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        self.canvas.backgroundColor = .clearColor()
        
        self.clearButton.setImage(UIImage(named: "reset"), forState: .Normal)
        self.clearButton.setImage(UIImage(named: "reset_highlighted"), forState: .Highlighted)
        self.clearButton.backgroundColor = UIColor.swiftLightOrange()
        self.clearButton.layer.cornerRadius = 6
        self.clearButton.minimumScale = 0.92
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
        
        self.clearButton.constrainUsing(constraints: [
            Constraint.rr : (of: self, offset: -15),
            Constraint.w : (of: nil, offset: 100),
            Constraint.bb : (of: self, offset: -15),
            Constraint.h : (of: nil, offset: 60)])
        
        super.updateConstraints()
    }
}
