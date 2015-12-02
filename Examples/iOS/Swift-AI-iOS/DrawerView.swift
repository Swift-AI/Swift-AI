//
//  DrawerView.swift
//
//  Created by Collin Hundley on 9/1/15.
//

import UIKit
import APKit

class DrawerView: UIView {
    
    // Header
    var headerView: APBorderView!
    let headerLabel = UILabel()
    
    // Sections
    let tableView = UITableView()
    
    // Footer
    var footerView: APBorderView!
    let footerLabel = APMultilineLabel()
    
    convenience init() {
        self.init(frame: CGRectZero)
        self.headerView = APBorderView(border: .Bottom, color: .white, weight: 1)
        self.footerView = APBorderView(border: .Top, color: .white, weight: 1)
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
        self.addSubviews([self.headerView, self.tableView, self.footerView])
        self.headerView.addSubviews([self.headerLabel])
        self.footerView.addSubview(self.footerLabel)
        
        // Style View
        self.backgroundColor = .drawerColor()
        
        // Style Subviews
        self.headerView.backgroundColor = .clear

        self.headerLabel.text = "Example Projects"
        self.headerLabel.font = UIFont.swiftFontOfSize(20)
        self.headerLabel.textColor = .swiftLightGray()
        
        self.tableView.backgroundColor = .drawerColor()
        self.tableView.scrollEnabled = false
        
        self.footerView.backgroundColor = .clear
        
        self.footerLabel.text = "Feedback or ideas?\nLet us know on Github"
        self.footerLabel.font = UIFont.swiftFontOfSize(13)
        self.footerLabel.textColor = .swiftLightGray()
        self.footerLabel.textAlignment = .Center
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        self.headerView.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 0),
            Constraint.rr : (of: self, offset: 0),
            Constraint.tt : (of: self, offset: 0),
            Constraint.h : (of: nil, offset: 60)])
        
        self.headerLabel.centerInSuperview()
        
        self.tableView.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 0),
            Constraint.rr : (of: self, offset: 0),
            Constraint.tb : (of: self.headerView, offset: 0),
            Constraint.h : (of: nil, offset: CGFloat(self.tableView.numberOfRowsInSection(0) * 70))])
        
        self.footerView.constrainUsing(constraints: [
            Constraint.ll : (of: self, offset: 0),
            Constraint.rr : (of: self, offset: 0),
            Constraint.bb : (of: self, offset: 0),
            Constraint.h : (of: nil, offset: 60)])
        
        self.footerLabel.constrainUsing(constraints: [
            Constraint.ll : (of: self.footerView, offset: 15),
            Constraint.rr : (of: self.footerView, offset: -15),
            Constraint.cycy : (of: self.footerView, offset: 0)])
        
        super.updateConstraints()
    }
    
}