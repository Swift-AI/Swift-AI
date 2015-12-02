//
//  Fonts.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/1/15.
//

import UIKit

extension UIFont {
    
    class func swiftFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans", size: size)!
    }
    
    class func swiftLightFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size)!
    }
    
    class func swiftBoldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!
    }
    
    class func swiftSemiboldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size)!
    }
    
    class func swiftItalicFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Italic", size: size)!
    }
    
}