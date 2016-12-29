//
//  DrawerView.swift
//
//  Created by Collin Hundley on 9/1/15.
//

import UIKit

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
        self.init(frame: CGRect.zero)
        self.headerView = APBorderView(border: .bottom, color: .white, weight: 1)
        self.footerView = APBorderView(border: .top, color: .white, weight: 1)
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
        self.addSubviews(self.headerView, self.tableView, self.footerView)
        self.headerView.addSubviews(self.headerLabel)
        self.footerView.addSubview(self.footerLabel)
        
        // Style View
        self.backgroundColor = .drawerColor()
        
        // Style Subviews
        self.headerView.backgroundColor = .clear

        self.headerLabel.text = "Example Projects"
        self.headerLabel.font = UIFont.swiftFontOfSize(18)
        self.headerLabel.textColor = .swiftLightGray()
        
        self.tableView.backgroundColor = .drawerColor()
        self.tableView.isScrollEnabled = false
        
        self.footerView.backgroundColor = .clear
        
        let text = NSMutableAttributedString(string: "Feedback or ideas?\nLet us know on Github")
        text.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(text.length - 6, 6))
        self.footerLabel.attributedText = text
//        self.footerLabel.text = "Feedback or ideas?\nLet us know on Github"
        self.footerLabel.font = UIFont.swiftFontOfSize(13)
        self.footerLabel.textColor = .swiftLightGray()
        self.footerLabel.textAlignment = .center
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        headerView.addConstraints(
            Constraint.llrr.of(self),
            Constraint.tt.of(self),
            Constraint.h.of(60))
        
//        self.headerView.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 0),
//            Constraint.rr : (of: self, offset: 0),
//            Constraint.tt : (of: self, offset: 0),
//            Constraint.h : (of: nil, offset: 60)])
        
        headerLabel.centerInSuperview()
        
        tableView.addConstraints(
            Constraint.llrr.of(self),
            Constraint.tb.of(headerView),
            Constraint.h.of(CGFloat(tableView.numberOfRows(inSection: 0) * 70)))
        
//        self.tableView.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 0),
//            Constraint.rr : (of: self, offset: 0),
//            Constraint.tb : (of: self.headerView, offset: 0),
//            Constraint.h : (of: nil, offset: CGFloat(self.tableView.numberOfRowsInSection(0) * 70))])
        
        footerView.addConstraints(
            Constraint.llrr.of(self),
            Constraint.bb.of(self),
            Constraint.h.of(60))
        
//        self.footerView.constrainUsing(constraints: [
//            Constraint.ll : (of: self, offset: 0),
//            Constraint.rr : (of: self, offset: 0),
//            Constraint.bb : (of: self, offset: 0),
//            Constraint.h : (of: nil, offset: 60)])
        
        footerLabel.addConstraints(
            Constraint.llrr.of(footerView, offset: 15),
            Constraint.cycy.of(footerView))
        
//        self.footerLabel.constrainUsing(constraints: [
//            Constraint.ll : (of: self.footerView, offset: 15),
//            Constraint.rr : (of: self.footerView, offset: -15),
//            Constraint.cycy : (of: self.footerView, offset: 0)])
        
        super.updateConstraints()
    }
    
}
