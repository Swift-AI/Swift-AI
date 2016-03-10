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
    let field1 = APMultilineLabel()
    let label2 = UILabel()
    let field2 = APMultilineLabel()
    let label3 = UILabel()
    let field3 = APMultilineLabel()
    
    let dismissButton = APSpringButton()
    let dismissArrow = UIImageView()
    
    func configureSubviews() {
        // Add Subviews
        self.addSubviews([self.blurView, self.label1, self.field1, self.label2, self.field2, self.label3, self.field3, self.dismissArrow, self.dismissButton])
        
        // Style View
        
        // Style Subviews
        
        self.label1.textColor = .whiteColor()
        self.label1.font = UIFont.swiftFontOfSize(18)
        self.label1.backgroundColor = .clearColor()
        
        self.label2.textColor = .whiteColor()
        self.label2.font = UIFont.swiftFontOfSize(18)
        self.label2.backgroundColor = .clearColor()
        
        self.label3.textColor = .whiteColor()
        self.label3.font = UIFont.swiftFontOfSize(18)
        self.label3.backgroundColor = .clearColor()
        
        self.field1.textColor = .whiteColor()
        self.field1.font = UIFont.swiftFontOfSize(16)
        self.field1.backgroundColor = .clearColor()
        self.field1.userInteractionEnabled = false
        
        self.field2.textColor = .whiteColor()
        self.field2.font = UIFont.swiftFontOfSize(16)
        self.field2.backgroundColor = .clearColor()
        self.field2.userInteractionEnabled = false
        
        self.field3.textColor = .whiteColor()
        self.field3.font = UIFont.swiftFontOfSize(16)
        self.field3.backgroundColor = .clearColor()
        self.field3.userInteractionEnabled = false
        
        self.dismissButton.setTitle("Dismiss", forState: .Normal)
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
            Constraint.tb : (of: self.label1, offset: 10)])
        
        self.label2.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.tb : (of: self.field1, offset: 25)])
        
        self.field2.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.rr : (of: self, offset: -15),
            Constraint.tb : (of: self.label2, offset: 10)])
        
        self.label3.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.tb : (of: self.field2, offset: 25)])
        
        self.field3.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.rr : (of: self, offset: -15),
            Constraint.tb : (of: self.label3, offset: 10)])
        
        self.dismissButton.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.bb : (of: self, offset: -20)])
        
        self.dismissArrow.constrainUsing(constraints: [
            Constraint.cxcx : (of: self, offset: 0),
            Constraint.tb : (of: self.dismissButton, offset: -5)])
        
        super.updateConstraints()
    }
}
