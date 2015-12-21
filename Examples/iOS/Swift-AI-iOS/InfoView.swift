//
//  InfoView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/30/15.
//

import UIKit
import APKit

class InfoView: UIView {
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    let label1 = UILabel()
    let field1 = UITextView()
    
    let dismissButton = APSpringButton()
    let dismissArrow = UIImageView()
    
    func configureSubviews() {
        // Add Subviews
        self.addSubviews([self.blurView, self.label1, self.field1, self.dismissArrow, self.dismissButton])
        
        // Style View
        
        // Style Subviews
        
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
        
        self.dismissButton.setTitle("Pull to dismiss", forState: .Normal)
        self.dismissButton.titleLabel?.textColor = .whiteColor()
        self.dismissButton.titleLabel?.font = UIFont.swiftFontOfSize(14)
        self.dismissButton.backgroundColor = .clearColor()
        
        self.dismissArrow.image = UIImage(named: "dismiss_arrow")
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        
        self.blurView.fillSuperview()
        
        self.label1.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.tt : (of: self, offset: 64)])
        
        self.field1.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.rr : (of: self, offset: -15),
            Constraint.tb : (of: self.label1, offset: 10),
            Constraint.bt : (of: self.dismissButton, offset: -15)])
        
        self.dismissButton.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.bb : (of: self, offset: -20)])
        
        self.dismissArrow.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.tb : (of: self.dismissButton, offset: -5)])
        
        super.updateConstraints()
    }
}
