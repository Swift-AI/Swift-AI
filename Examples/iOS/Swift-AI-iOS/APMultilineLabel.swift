//
//  APMultilineLabel.swift
//  Copyright © 2015 Appsidian. All rights reserved.


import UIKit

    /// A subclass of UILabel that automatically wraps text to width of its own frame.
    /// May be used with AutoLayout without providing a preferredMaxLayoutWidth.
    /// IMPORTANT: Do not assign a height constraint to APMultiLineLabels
public class APMultilineLabel: UILabel {
    
    public init() {
        super.init(frame: CGRectZero)
        self.lineBreakMode = .ByWordWrapping
        self.numberOfLines = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.preferredMaxLayoutWidth = self.bounds.size.width
    }
    
}
