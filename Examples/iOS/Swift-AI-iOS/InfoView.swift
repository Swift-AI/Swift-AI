//
//  InfoView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/30/15.
//

import UIKit

class InfoView: UIView {
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
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
        self.addSubviews(self.blurView, self.label1, self.field1, self.label2, self.field2, self.label3, self.field3, self.dismissArrow, self.dismissButton)
        
        // Style View
        
        // Style Subviews
        
        self.label1.textColor = .white
        self.label1.font = UIFont.swiftFontOfSize(18)
        self.label1.backgroundColor = .clear
        
        self.label2.textColor = .white
        self.label2.font = UIFont.swiftFontOfSize(18)
        self.label2.backgroundColor = .clear
        
        self.label3.textColor = .white
        self.label3.font = UIFont.swiftFontOfSize(18)
        self.label3.backgroundColor = .clear
        
        self.field1.textColor = .white
        self.field1.font = UIFont.swiftFontOfSize(16)
        self.field1.backgroundColor = .clear
        self.field1.isUserInteractionEnabled = false
        
        self.field2.textColor = .white
        self.field2.font = UIFont.swiftFontOfSize(16)
        self.field2.backgroundColor = .clear
        self.field2.isUserInteractionEnabled = false
        
        self.field3.textColor = .white
        self.field3.font = UIFont.swiftFontOfSize(16)
        self.field3.backgroundColor = .clear
        self.field3.isUserInteractionEnabled = false
        
        self.dismissButton.setTitle("Dismiss", for: UIControlState())
        self.dismissButton.titleLabel?.textColor = .white
        self.dismissButton.titleLabel?.font = UIFont.swiftFontOfSize(14)
        self.dismissButton.backgroundColor = .clear
        
        self.dismissArrow.image = UIImage(named: "dismiss_arrow")
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        
        self.blurView.fillSuperview()
        
        label1.addConstraints(
            Constraint.ll.of(self, offset: 15),
            Constraint.tt.of(self, offset: 64))
        
//        self.label1.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 15),
//            Constraint.tt : (of: self, offset: 64)])
        
        field1.addConstraints(
            Constraint.llrr.of(self, offset: 15),
            Constraint.tb.of(label1, offset: 10))
        
//        self.field1.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 15),
//            Constraint.rr : (of: self, offset: -15),
//            Constraint.tb : (of: self.label1, offset: 10)])
        
        label2.addConstraints(
            Constraint.ll.of(self, offset: 15),
            Constraint.tb.of(field1, offset: 25))
        
//        self.label2.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 15),
//            Constraint.tb : (of: self.field1, offset: 25)])
        
        field2.addConstraints(
            Constraint.llrr.of(self, offset: 15),
            Constraint.tb.of(label2, offset: 10))
        
//        self.field2.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 15),
//            Constraint.rr : (of: self, offset: -15),
//            Constraint.tb : (of: self.label2, offset: 10)])
        
        label3.addConstraints(
            Constraint.ll.of(self, offset: 15),
            Constraint.tb.of(field2, offset: 25))
        
//        self.label3.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 15),
//            Constraint.tb : (of: self.field2, offset: 25)])
        
        field3.addConstraints(
            Constraint.llrr.of(self, offset: 15),
            Constraint.tb.of(label3, offset: 10))
        
//        self.field3.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 15),
//            Constraint.rr : (of: self, offset: -15),
//            Constraint.tb : (of: self.label3, offset: 10)])
        
        dismissButton.addConstraints(
            Constraint.cxcx.of(self),
            Constraint.bb.of(self, offset: -20))
        
//        self.dismissButton.constrainUsing(constraints: [
//            Constraint.cxcx : (of: self, offset: 0),
//            Constraint.bb : (of: self, offset: -20)])
        
        dismissArrow.addConstraints(
            Constraint.cxcx.of(self),
            Constraint.tb.of(dismissButton, offset: -5))
        
//        self.dismissArrow.constrainUsing(constraints: [
//            Constraint.cxcx : (of: self, offset: 0),
//            Constraint.tb : (of: self.dismissButton, offset: -5)])
        
        super.updateConstraints()
    }
}
