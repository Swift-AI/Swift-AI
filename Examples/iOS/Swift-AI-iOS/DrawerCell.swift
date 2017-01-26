//
//  DrawerCell.swift
//
//  Created by Collin Hundley on 9/1/15.
//

import UIKit

class DrawerCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    fileprivate let selectionView = UIView()
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: nil)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        // Add Subviews
        self.contentView.addSubviews(self.titleLabel, self.descriptionLabel)
        
        // Style View
        self.backgroundColor = .drawerColor()
        self.selectedBackgroundView = self.selectionView
        
        // Style Subviews
        self.titleLabel.textColor = .swiftLightGray()
        self.titleLabel.font = UIFont.swiftFontOfSize(18)
        
        self.descriptionLabel.textColor = .swiftLightGray()
        self.descriptionLabel.font = UIFont.swiftFontOfSize(13)
        
        self.selectionView.backgroundColor = UIColor(white: 1, alpha: 0.4)
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        titleLabel.addConstraints(
            Constraint.ll.of(contentView, offset: 15),
            Constraint.cycy.of(contentView, offset: -12))
        
//        self.titleLabel.constrainUsing(constraints: [
//            Constraint.ll : (of: self.contentView, offset: 15),
//            Constraint.cycy : (of: self.contentView, offset: -12)])
        
        descriptionLabel.addConstraints(
            Constraint.ll.of(titleLabel),
            Constraint.cycy.of(contentView, offset: 12))
        
//        self.descriptionLabel.constrainUsing(constraints: [
//            Constraint.ll : (of: self.titleLabel, offset: 0),
//            Constraint.cycy : (of: self.contentView, offset: 12)])
        
        super.updateConstraints()
    }
}
