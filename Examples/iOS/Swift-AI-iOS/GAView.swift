//
//  GAView.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/25/15.
//

import UIKit

class GAView: UIView {
    
    let tempLabel = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
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
        self.addSubview(self.tempLabel)
        
        // Style View
        self.backgroundColor = .white
        
        // Style Subviews
        self.tempLabel.text = "Genetic Algorithm example coming soon!"
        self.tempLabel.textColor = .swiftDarkOrange()
        self.tempLabel.font = UIFont.swiftFontOfSize(15)
        
    }
    
    override func updateConstraints() {
        
        // Configure Subviews
        self.configureSubviews()
        
        // Add Constraints
        self.tempLabel.centerInSuperview()
        
        super.updateConstraints()
    }
}
