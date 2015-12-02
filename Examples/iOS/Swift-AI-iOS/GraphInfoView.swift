//
//  GraphInfoView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/30/15.
//

import UIKit
import APKit

class GraphInfoView: UIView {
    
    let dismissButton = UIButton()
    let label1 = UILabel()
    let field1 = UITextView()
    
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
        self.addSubviews([self.dismissButton, self.label1, self.field1])
        
        // Style View
        self.backgroundColor = .swiftDarkOrange()
        
        // Style Subviews
        self.dismissButton.setTitle("Dismiss", forState: .Normal)
        self.dismissButton.backgroundColor = .swiftLightOrange()
        self.dismissButton.setTitleColor(.redColor(), forState: .Highlighted)
        
        self.label1.text = "What's going on?"
        self.label1.textColor = .whiteColor()
        self.label1.font = UIFont.swiftFontOfSize(20)
        self.label1.backgroundColor = .clearColor()
        
        self.field1.text = "A description about this example will go right here."
        self.field1.textColor = .whiteColor()
        self.field1.font = UIFont.swiftFontOfSize(18)
        self.field1.backgroundColor = .clearColor()
        self.field1.userInteractionEnabled = false
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        self.dismissButton.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 0),
            Constraint.rr : (of: self, offset: 0),
            Constraint.bb : (of: self, offset: 0),
            Constraint.h : (of: nil, offset: 64)])
        
        self.label1.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.tt : (of: self, offset: 64)])
        
        self.field1.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 15),
            Constraint.rr : (of: self, offset: -15),
            Constraint.tb : (of: self.label1, offset: 15),
            Constraint.bt : (of: self.dismissButton, offset: 0)])
        
        super.updateConstraints()
    }
}
