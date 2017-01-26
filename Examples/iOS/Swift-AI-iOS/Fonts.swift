//
//  Fonts.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/1/15.
//

import UIKit

extension UIFont {
    
    class func swiftFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans", size: size)!
    }
    
    class func swiftLightFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size)!
    }
    
    class func swiftBoldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!
    }
    
    class func swiftSemiboldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size)!
    }
    
    class func swiftItalicFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Italic", size: size)!
    }
    
}
