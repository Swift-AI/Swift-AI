//
//  InfoView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/30/15.
//

import UIKit
import APKit

class InfoView: UIVisualEffectView {
    
    let dismissButton = APSpringButton()
    let label1 = UILabel()
    let field1 = UITextView()
    
    func configureSubviews() {
        // Add Subviews
        self.addSubviews([self.dismissButton, self.label1, self.field1])
        
        // Style View
        
        // Style Subviews
        self.dismissButton.setTitle("Dismiss", forState: .Normal)
        self.dismissButton.backgroundColor = .swiftMediumGray()
        self.dismissButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        self.dismissButton.addTarget(DrawerNavigationController.globalDrawerController(), action: "dismissInfoView", forControlEvents: .TouchUpInside)
        self.dismissButton.layer.cornerRadius = 6
        self.dismissButton.minimumScale = 0.92
        
        self.label1.text = "What's going on?"
        self.label1.textColor = .whiteColor()
        self.label1.font = UIFont.swiftFontOfSize(18)
        self.label1.backgroundColor = .clearColor()
        
        self.field1.text = "This is where the description will go."
        self.field1.textColor = .whiteColor()
        self.field1.font = UIFont.swiftFontOfSize(16)
        self.field1.backgroundColor = .clearColor()
        self.field1.userInteractionEnabled = false
        self.field1.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        self.dismissButton.constrainUsing(constraints: [
            Constraint.rr : (of: self, offset: -15),
            Constraint.w : (of: nil, offset: 100),
            Constraint.bb : (of: self, offset: -15),
            Constraint.h : (of: nil, offset: 50)])
        
        self.label1.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.tt : (of: self, offset: 64)])
        
        self.field1.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.rr : (of: self, offset: -15),
            Constraint.tb : (of: self.label1, offset: 10),
            Constraint.bt : (of: self.dismissButton, offset: 0)])
        
        super.updateConstraints()
    }
}
