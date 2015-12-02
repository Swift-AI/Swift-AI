//
//  DrawerCell.swift
//
//  Created by Collin Hundley on 9/1/15.
//

import UIKit
import APKit

class DrawerCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    private let selectionView = UIView()
    
    convenience init() {
        self.init(style: .Default, reuseIdentifier: nil)
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
        self.contentView.addSubviews([self.titleLabel, self.descriptionLabel])
        
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
        self.titleLabel.constrainUsing(constraints: [
            Constraint.ll : (of: self.contentView, offset: 15),
            Constraint.cycy : (of: self.contentView, offset: -12)])
        
        self.descriptionLabel.constrainUsing(constraints: [
            Constraint.ll : (of: self.titleLabel, offset: 0),
            Constraint.cycy : (of: self.contentView, offset: 12)])
        
//        self.selectionView.fillSuperview()
        
        super.updateConstraints()
    }
}
