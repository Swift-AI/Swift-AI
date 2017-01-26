//
//  APConstraints.swift
//  Copyright (c) 2015 Appsidian. All rights reserved.
//

/*

CODE SNIPPETS: Select the following blocks of code and drag into your code snippets drawer.


Title: APConstraints
Summary: Add multiple constraints.
Completion Shortcut: addConstraints
Completion Scope: All

addConstraints(
Constraint.<##>,
Constraint.<##>,
Constraint.<##>,
Constraint.<##>)

OR ALTERNATIVELY...

addConstraints(
Constraint.<#constraint#>.of(<#AnyObject#>),
Constraint.<#constraint#>.of(<#AnyObject#>))

------------------

Title: Single Constraint
Summary: Single APConstraint.
Completion Shortcut: Constraint
Completion Scope: All

Constraint.<#constraint#>.of(<#AnyObject#>)


*/

import UIKit


// MARK: - Constraint Enum
// ----------------------------------------------------------------------------------------------------------------------------------------------
public enum Constraint {
    // X Axis
    case leftToLeftRightToRight
    case leftToLeft
    case leftToRight
    case leftToCenterX
    case rightToRight
    case rightToLeft
    case rightToCenterX
    case centerXToCenterX
    case centerXToLeft
    case centerXToRight
    case width
    case maxWidth
    case minWidth
    case intrinsicContentWidth
    case widthHeight
    // Y Axis
    case heightWidth
    case topToTopBottomToBottom
    case topToTop
    case topToBottom
    case topToCenterY
    case bottomToBottom
    case bottomToTop
    case bottomToCenterY
    case centerYToCenterY
    case centerYToTop
    case centerYToBottom
    case height
    case maxHeight
    case minHeight
    case intrinsicContentHeight
    case baseline
    case `default`
    
    // X Axis
    public static let llrr  = Constraint.leftToLeftRightToRight
    public static let ll    = Constraint.leftToLeft
    public static let lr    = Constraint.leftToRight
    public static let lcx   = Constraint.leftToCenterX
    public static let rr    = Constraint.rightToRight
    public static let rl    = Constraint.rightToLeft
    public static let rcx   = Constraint.rightToCenterX
    public static let cxcx  = Constraint.centerXToCenterX
    public static let cxl   = Constraint.centerXToLeft
    public static let cxr   = Constraint.centerXToRight
    public static let w     = Constraint.width
    public static let maxw  = Constraint.maxWidth
    public static let minw  = Constraint.minWidth
    public static let iw    = Constraint.intrinsicContentWidth
    public static let wh    = Constraint.widthHeight // @collin, I changed wh and hw to give the view the same height and width at the same time
    // Y Axis
    public static let hw    = Constraint.heightWidth // instead of constraining the width to the height (or w to h) of another view
    public static let ttbb  = Constraint.topToTopBottomToBottom
    public static let tt    = Constraint.topToTop
    public static let tb    = Constraint.topToBottom
    public static let tcy   = Constraint.topToCenterY
    public static let bb    = Constraint.bottomToBottom
    public static let bt    = Constraint.bottomToTop
    public static let bcy   = Constraint.bottomToCenterY
    public static let cycy  = Constraint.centerYToCenterY
    public static let cyt   = Constraint.centerYToTop
    public static let cyb   = Constraint.centerYToBottom
    public static let h     = Constraint.height
    public static let maxh  = Constraint.maxHeight
    public static let minh  = Constraint.minHeight
    public static let ih    = Constraint.intrinsicContentHeight
    public static let bsln  = Constraint.baseline
    
    init() {
        self = .default
    }
    
    // Methods for buildling constraints
    
    public func of(_ of: UIView?, relation: NSLayoutRelation, offset: CGFloat, multiplier: CGFloat, priority: UILayoutPriority) -> APConstraint {
        return APConstraint(constraint: self, of: of, relation: relation, offset: offset, multiplier: multiplier, priority: priority)
    }
    
    public func of(_ of: UIView?, offset: CGFloat, priority: UILayoutPriority) -> APConstraint {
        return APConstraint(constraint: self, of: of, offset: offset, priority: priority)
    }
    
    public func of(_ of: UIView?, offset: CGFloat, multiplier: CGFloat) -> APConstraint {
        return APConstraint(constraint: self, of: of, multiplier: multiplier, offset: offset)
    }
    
    public func of(_ of: UIView?, offset: CGFloat) -> APConstraint {
        return APConstraint(constraint: self, of: of, offset: offset)
    }
    
    public func of(_ of: UIView?, priority: UILayoutPriority) -> APConstraint {
        return APConstraint(constraint: self, of: of, offset: 0, priority: priority)
    }
    
    public func of(_ offset: CGFloat, priority: UILayoutPriority) -> APConstraint {
        return APConstraint(constraint: self, of: nil, offset: offset, priority: priority)
    }
    
    public func of(_ offset: CGFloat) -> APConstraint {
        return APConstraint(constraint: self, offset: offset)
    }
    
    public func of(_ of: UIView?) -> APConstraint {
        return APConstraint(constraint: self, of: of, offset: 0)
    }
    
    public func of(_ of: UIView?, multiplier: CGFloat) -> APConstraint {
        return APConstraint(constraint: self, of: of, multiplier: multiplier)
    }
    
    // Methods for determining type of constraint
    fileprivate func isXAxisConstraint() -> Bool {
        return self == .llrr || self == .ll || self == .lr || self == .lcx || self == .rr || self == .rl || self == .rcx || self == .cxcx || self == .cxl || self == .cxr || self == .w || self == .iw || self == .wh // don't include maxw
    }
    
    fileprivate func isCenterXConstraint() -> Bool {
        return self == .cxcx || self == .cxl || self == .cxr
    }
    
    fileprivate func isYAxisConstraint() -> Bool {
        return  self == .hw || self == .ttbb || self == .tt || self == .tb || self == .tcy || self == .bb || self == .bt || self == .bcy || self == .cycy || self == .cyt || self == .cyb || self == .h || self == .ih || self == .bsln // don't include maxh
    }
    
    fileprivate func isCenterYConstraint() -> Bool {
        return  self == .cycy || self == .cyt || self == .cyb
    }
}


// MARK: - APConstraint
// ----------------------------------------------------------------------------------------------------------------------------------------------
/// To create APConstraints use the convenience `of` methods on the Constraint enum like so:
/// `subview.addConstraints(Constraint.ll.of(superview))`
/// Where `of(...)` returns an APConstraint which can be used to quickly add NSLayoutConstraints
open class APConstraint {
    var constraint: Constraint
    var of: UIView?
    var multiplier: CGFloat?
    var offset: CGFloat
    var priority: UILayoutPriority?
    var relation: NSLayoutRelation?
    
    fileprivate init(constraint: Constraint, of: UIView?, relation: NSLayoutRelation, offset: CGFloat, multiplier: CGFloat?, priority: UILayoutPriority?) {
        self.constraint = constraint
        self.of = of
        self.offset = offset
        self.relation = relation
        self.multiplier = multiplier
        self.priority = priority
    }
    
    fileprivate convenience init(constraint: Constraint, of: UIView?, multiplier: CGFloat?, offset: CGFloat) {
        self.init(constraint: constraint, of: of, relation: .equal, offset: offset, multiplier: multiplier, priority: UILayoutPriorityRequired)
    }
    
    fileprivate convenience init(constraint: Constraint, of: UIView?, offset: CGFloat, priority: UILayoutPriority) {
        self.init(constraint: constraint, of: of, relation: .equal, offset: offset, multiplier: 1.0, priority: priority)
    }
    
    fileprivate convenience init(constraint: Constraint, of: UIView?, offset: CGFloat) {
        self.init(constraint: constraint, of: of, relation: .equal, offset: offset, multiplier: 1.0, priority: UILayoutPriorityRequired)
    }
    
    fileprivate convenience init(constraint: Constraint, offset: CGFloat) {
        self.init(constraint: constraint, of: nil, relation: .equal, offset: offset, multiplier: 1.0, priority: UILayoutPriorityRequired)
    }
    
    fileprivate convenience init(constraint: Constraint, of: UIView?, multiplier: CGFloat) {
        self.init(constraint: constraint, of: of, relation: .equal, offset: 0, multiplier: multiplier, priority: UILayoutPriorityRequired)
    }
}


// MARK: - Magic
// ----------------------------------------------------------------------------------------------------------------------------------------------
public extension UIView {
    
    /// Instead of initializing `APConstraint` objects directly, use the convenience `of(...)` methods on the `Constraint` class like so:
    /// `subview.addConstraints(Constraint.ll.of(superview))`
    public func addConstraints(_ constraints: APConstraint...) {
        // Check for existence of superview before attempting to apply constraints.
        guard var parent = self.superview else {
            return print("Warning: \(self) has not been added to a superview. Constraints will not be applied.")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        removeAllConstraints()
        
        // Check if the super-superview is a UICollectionViewCell or UITableViewCell and adjust superview to super-superview if necessary.
        if let superclass: AnyClass = self.superview?.superview?.superclass {
            if superclass === UICollectionViewCell.self || superclass === UITableViewCell.self {
                parent = self.superview!.superview!
            }
        }
        
        for constraint in constraints {
            let multiplier = constraint.multiplier ?? 1.0
            var priority = constraint.priority ?? UILayoutPriorityRequired
            let relation = constraint.relation ?? .equal
            
            var newConstraint: NSLayoutConstraint?
            var secondNewConstraint: NSLayoutConstraint?
            
            switch constraint.constraint {
                // X Axis ---------------------------------------------------------------------------------------------------------------------------
            case .leftToLeftRightToRight:
                newConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: relation, toItem: constraint.of, attribute: .left, multiplier: multiplier, constant: constraint.offset)
                secondNewConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: relation, toItem: constraint.of, attribute: .right, multiplier: multiplier, constant: -constraint.offset)
            case .leftToLeft:
                newConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: relation, toItem: constraint.of, attribute: .left, multiplier: multiplier, constant: constraint.offset)
            case .leftToRight:
                newConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: relation, toItem: constraint.of, attribute: .right, multiplier: multiplier, constant: constraint.offset)
            case .leftToCenterX:
                newConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: relation, toItem: constraint.of, attribute: .centerX, multiplier: multiplier, constant: constraint.offset)
            case .rightToRight:
                newConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: relation, toItem: constraint.of, attribute: .right, multiplier: multiplier, constant: constraint.offset)
            case .rightToLeft:
                newConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: relation, toItem: constraint.of, attribute: .left, multiplier: multiplier, constant: constraint.offset)
            case .rightToCenterX:
                newConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: relation, toItem: constraint.of, attribute: .centerX, multiplier: multiplier, constant: constraint.offset)
            case .centerXToCenterX:
                newConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: relation, toItem: constraint.of, attribute: .centerX, multiplier: multiplier, constant: constraint.offset)
            case .centerXToLeft:
                newConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: relation, toItem: constraint.of, attribute: .left, multiplier: multiplier, constant: constraint.offset)
            case .centerXToRight:
                newConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: relation, toItem: constraint.of, attribute: .right, multiplier: multiplier, constant: constraint.offset)
            case .width:
                newConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, toItem: constraint.of, attribute: .width, multiplier: multiplier, constant: constraint.offset)
            case .maxWidth:
                newConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: constraint.of, attribute: .width, multiplier: multiplier, constant: constraint.offset)
            case .minWidth:
                newConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: constraint.of, attribute: .width, multiplier: multiplier, constant: constraint.offset)
            case .intrinsicContentWidth:
                newConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, toItem: constraint.of, attribute: .width, multiplier: multiplier, constant: intrinsicContentSize.width + constraint.offset)
            case .widthHeight:
                if constraint.of == nil {
                    // Constrain width and height to a constant (used if only a CGFloat is given)
                    newConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constraint.offset)
                    secondNewConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constraint.offset)
                } else {
                    // Constrain width to height of view2 (used if a UIView is given)
                    newConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, toItem: constraint.of, attribute: .height, multiplier: multiplier, constant: constraint.offset)
                }
            case .heightWidth:
                if constraint.of == nil {
                    // Constrain width and height to a constant (used if only a CGFloat is given)
                    newConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constraint.offset)
                    secondNewConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constraint.offset)
                } else {
                    // Constrain height to width of view2 (used if a UIView is given)
                    newConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, toItem: constraint.of, attribute: .width, multiplier: multiplier, constant: constraint.offset)
                }
                
                // Y Axis ---------------------------------------------------------------------------------------------------------------------------
            case .topToTopBottomToBottom:
                newConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relation, toItem: constraint.of, attribute: .top, multiplier: multiplier, constant: constraint.offset)
                secondNewConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: relation, toItem: constraint.of, attribute: .bottom, multiplier: multiplier, constant: -constraint.offset)
            case .topToTop:
                newConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relation, toItem: constraint.of, attribute: .top, multiplier: multiplier, constant: constraint.offset)
            case .topToBottom:
                newConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relation, toItem: constraint.of, attribute: .bottom, multiplier: multiplier, constant: constraint.offset)
            case .topToCenterY:
                newConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relation, toItem: constraint.of, attribute: .centerY, multiplier: multiplier, constant: constraint.offset)
            case .bottomToBottom:
                newConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: relation, toItem: constraint.of, attribute: .bottom, multiplier: multiplier, constant: constraint.offset)
            case .bottomToTop:
                newConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: relation, toItem: constraint.of, attribute: .top, multiplier: multiplier, constant: constraint.offset)
            case .bottomToCenterY:
                newConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: relation, toItem: constraint.of, attribute: .centerY, multiplier: multiplier, constant: constraint.offset)
            case .centerYToCenterY:
                newConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: relation, toItem: constraint.of, attribute: .centerY, multiplier: multiplier, constant: constraint.offset)
            case .centerYToTop:
                newConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: relation, toItem: constraint.of, attribute: .top, multiplier: multiplier, constant: constraint.offset)
            case .centerYToBottom:
                newConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: relation, toItem: constraint.of, attribute: .bottom, multiplier: multiplier, constant: constraint.offset)
            case .height:
                newConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, toItem: constraint.of, attribute: .height, multiplier: multiplier, constant: constraint.offset)
            case .maxHeight:
                newConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: constraint.of, attribute: .height, multiplier: multiplier, constant: constraint.offset)
            case .minHeight:
                newConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: constraint.of, attribute: .height, multiplier: multiplier, constant: constraint.offset)
            case .intrinsicContentHeight:
                newConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, toItem: constraint.of, attribute: .height, multiplier: multiplier, constant: intrinsicContentSize.height + constraint.offset)
            case .baseline:
                newConstraint = NSLayoutConstraint(item: self, attribute: .lastBaseline, relatedBy: relation, toItem: constraint.of, attribute: .lastBaseline, multiplier: multiplier, constant: constraint.offset)
            case .default:
                break
            }
            
            // Check to see if in the incoming array of constraints there exists either a Max/Min constraint, adjust priority accordingly
            if constraint.constraint.isXAxisConstraint() {
                if (constraints.filter { $0.constraint == .maxWidth || $0.constraint == .minWidth }).count > 0 {
                    priority = constraint.constraint.isCenterXConstraint() ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
                }
            }
            
            if constraint.constraint.isYAxisConstraint() {
                if (constraints.filter { $0.constraint == .maxHeight || $0.constraint == .minHeight }).count > 0 {
                    priority = constraint.constraint.isCenterYConstraint() ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
                }
            }
            
            guard let firstNewConstraint = newConstraint else {
                print("Warning: Invalid constraint given for \(self)")
                continue
            }
            
            firstNewConstraint.priority = priority
            parent.addConstraint(firstNewConstraint)
            
            if let secondNewConstraint = secondNewConstraint {
                secondNewConstraint.priority = priority
                parent.addConstraint(secondNewConstraint)
            }
        }
    }
    
    
    // MARK: - Updating Constraints
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    public func updateConstraint(_ constraint: Constraint, offset: CGFloat) {
        
        guard var parent = self.superview else {
            return print("Warning: \(self) has not been added to a superview. Constraints cannot be updated.")
        }
        
        if let superclass: AnyClass = self.superview?.superview?.superclass {
            if superclass === UICollectionViewCell.self || superclass === UITableViewCell.self {
                parent = self.superview!.superview!
            }
        }
        
        var firstAttribute: NSLayoutAttribute?
        var secondAttribute: NSLayoutAttribute?
        
        // Alternates will be set if the Constraint is a mix of two Constraints, e.g. .llrr
        var alternateFirstAttribute: NSLayoutAttribute?
        var alternateSecondAttribute: NSLayoutAttribute?
        
        
        // TODO: Reorder these to match the pattern above
        switch constraint {
        case .leftToLeftRightToRight:
            firstAttribute = .left; secondAttribute = .left
            alternateFirstAttribute = .right; alternateSecondAttribute = .right
        case .leftToLeft:
            firstAttribute = .left; secondAttribute = .left
        case .leftToRight:
            firstAttribute = .left; secondAttribute = .right
        case .leftToCenterX:
            firstAttribute = .left; secondAttribute = .centerX
        case .rightToRight:
            firstAttribute = .right; secondAttribute = .right
        case .rightToLeft:
            firstAttribute = .right; secondAttribute = .left
        case .rightToCenterX:
            firstAttribute = .right; secondAttribute = .centerX
        case .topToTopBottomToBottom:
            firstAttribute = .top; secondAttribute = .top
            alternateFirstAttribute = .bottom; alternateSecondAttribute = .bottom
        case .topToTop:
            firstAttribute = .top; secondAttribute = .top
        case .topToBottom:
            firstAttribute = .top; secondAttribute = .bottom
        case .topToCenterY:
            firstAttribute = .top; secondAttribute = .centerY
        case .bottomToBottom:
            firstAttribute = .bottom; secondAttribute = .bottom
        case .bottomToTop:
            firstAttribute = .bottom; secondAttribute = .top
        case .bottomToCenterY:
            firstAttribute = .bottom; secondAttribute = .centerY
        case .centerXToCenterX:
            firstAttribute = .centerX; secondAttribute = .centerX
        case .centerXToLeft:
            firstAttribute = .centerX; secondAttribute = .left
        case .centerXToRight:
            firstAttribute = .centerX; secondAttribute = .right
        case .centerYToCenterY:
            firstAttribute = .centerY; secondAttribute = .centerY
        case .centerYToTop:
            firstAttribute = .centerY; secondAttribute = .top
        case .centerYToBottom:
            firstAttribute = .centerY; secondAttribute = .bottom
        case .width:
            firstAttribute = .width; secondAttribute = .width
        case .intrinsicContentWidth:
            print("Updating constraint .iw is not yet supported")
            return
        case .height:
            firstAttribute = .height; secondAttribute = .height
        case .widthHeight:
            firstAttribute = .width; secondAttribute = .width
            alternateFirstAttribute = .height; alternateSecondAttribute = .height
        case .heightWidth:
            firstAttribute = .height; secondAttribute = .height
            alternateFirstAttribute = .width; alternateSecondAttribute = .width
        case .intrinsicContentHeight:
            print("Updating constraint .ih is not yet supported")
            return
        case .baseline:
            firstAttribute = .lastBaseline; secondAttribute = .lastBaseline
        case .maxWidth:
            print("Updating constraint .maxw is not yet supported")
            return
        case .minWidth:
            print("Updating constraint .minw is not yet supported")
            return
        case .maxHeight:
            print("Updating constraint .maxh is not yet supported")
            return
        case .minHeight:
            print("Updating constraint .minh is not yet supported")
            return
        case .default:
            break
        }
        
        for existingConstraint in parent.constraints {
            if existingConstraint.firstAttribute == firstAttribute && existingConstraint.secondAttribute == secondAttribute {
                existingConstraint.constant = offset
            }
            
            if let alternateFirstAttribute = alternateFirstAttribute, let alternateSecondAttribute = alternateSecondAttribute {
                if existingConstraint.firstAttribute == alternateFirstAttribute && existingConstraint.secondAttribute == alternateSecondAttribute {
                    existingConstraint.constant = -offset
                }
            }
        }
        
        self.setNeedsUpdateConstraints()
    }
    
    public func setNeedsUpdateConstraintsOnAllSubviews() {
        self.setNeedsUpdateConstraints()
        for subview in self.subviews {
            subview.setNeedsUpdateConstraintsOnAllSubviews()
        }
    }
    
    // MARK: - Removing Constraints
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    /// Removes all NSLayoutConstraints from the receiver.
    public func removeAllConstraints() {
        if let parent = self.superview {
            for constraint in parent.constraints {
                if constraint.firstItem as? UIView == self {
                    parent.removeConstraint(constraint)
                }
            }
        }
    }
    
    
    // MARK: - Orientation Constraint Convenience Methods
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    /// Usage: self.landscapeConstraints { (Add Constraints) }
    /// Takes advantage of Swift's trailing closure syntax.
    /// The code you include in the closure will only be executed if the device is in
    /// one of the landscape orientations
    public func landscapeConstraints(_ constraints: () -> Void) {
        if UIDevice.current.orientation.isLandscape {
            constraints()
        }
    }
    
    /// Usage: self.portraitConstraints { (Add Constraints) }
    /// Takes advantage of Swift's trailing closure syntax.
    /// The code you include in the closure will only be executed if the device is in
    /// one of the portrait orientations
    public func portraitConstraints(_ constraints: () -> Void) {
        if UIDevice.current.orientation.isPortrait {
            constraints()
        }
    }
    
    
    // MARK: - Convenience Constraint Macros
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    /// Constrains the receiver to fill the bounds of its superview.
    public func fillSuperview() {
        // Check for existence of superview before attempting to apply constraints.
        guard let superview = self.superview else {
            return print("Warning: \(self) has not been added to a superview. fillSuperview() constraint will not be applied.")
        }
        addConstraints(
            Constraint.llrr.of(superview),
            Constraint.ttbb.of(superview))
    }
    
    /// Centers the receiver in its superview.
    public func centerInSuperview() {
        // Check for existence of superview before attempting to apply constraints.
        guard let superview = self.superview else {
            return print("Warning: \(self) has not been added to a superview. centerInSuperview() constraint will not be applied.")
        }
        addConstraints(
            Constraint.cxcx.of(superview),
            Constraint.cycy.of(superview))
    }
    
    
    // MARK: - Convenience UIView Methods
    // ------------------------------------------------------------------------------------------------------------------------------------------
    
    /// Adds multiple subviews to the receiver.
    public func addSubviews(_ subviews: UIView...) {
        for view in subviews {
            self.addSubview(view)
        }
    }
    
}


// MARK: - Banned Dark Magic
// -------------------------------------------------------------------------------
public extension UIView {
    
    @available(*, deprecated: 1.1, message: "Use addConstraints(APConstraint...) instead")
    /// Applies an array of NSLayoutConstraints to the view, using a multiplier and an offset
    public func constrainUsing(constraints: [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)]) {
        var parent = self.superview!
        
        // Checks if constraining within a TableView/CollectionView cell
        // if let superclass: AnyClass? = self.superview?.superview?.superclass {

        if let superclass: AnyClass = self.superview?.superview?.superclass {
            if superclass === UICollectionViewCell.self || superclass === UITableViewCell.self {
                parent = self.superview!.superview!
            }
        }
        
        // Remove all existing Constraints
        self.removeAllConstraints()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        for constraint in constraints {
            switch constraint.0 {
            case .leftToLeftRightToRight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: constraint.1.of, attribute: .left, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: constraint.1.of, attribute: .right, multiplier: constraint.1.multiplier, constant: -constraint.1.offset))
            case .leftToLeft:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: constraint.1.of, attribute: .left, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .leftToRight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: constraint.1.of, attribute: .right, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .leftToCenterX:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerX, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .rightToRight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: constraint.1.of, attribute: .right, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .rightToLeft:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: constraint.1.of, attribute: .left, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .rightToCenterX:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerX, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .topToTopBottomToBottom:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: constraint.1.of, attribute: .top, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraint.1.of, attribute: .bottom, multiplier: constraint.1.multiplier, constant: -constraint.1.offset))
            case .topToTop:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: constraint.1.of, attribute: .top, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .topToBottom:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: constraint.1.of, attribute: .bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .topToCenterY:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerY, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .bottomToBottom:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraint.1.of, attribute: .bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .bottomToTop:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraint.1.of, attribute: .top, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .bottomToCenterY:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerY, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerXToCenterX:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerX, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerXToLeft:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: constraint.1.of, attribute: .left, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerXToRight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: constraint.1.of, attribute: .right, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerYToCenterY:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerY, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerYToTop:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: constraint.1.of, attribute: .top, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerYToBottom:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: constraint.1.of, attribute: .bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .width:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: constraint.1.of, attribute: .width, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .intrinsicContentWidth:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: constraint.1.of, attribute: .width, multiplier: constraint.1.multiplier, constant: (constraint.1.of as! UIView).intrinsicContentSize.width + constraint.1.offset))
            case .height:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: constraint.1.of, attribute: .height, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .intrinsicContentHeight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: constraint.1.of, attribute: .height, multiplier: constraint.1.multiplier, constant: (constraint.1.of as! UIView).intrinsicContentSize.height + constraint.1.offset))
            case .widthHeight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: constraint.1.of, attribute: .width, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: constraint.1.of, attribute: .height, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .heightWidth:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: constraint.1.of, attribute: .height, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: constraint.1.of, attribute: .width, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .baseline:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .lastBaseline, relatedBy: .equal, toItem: constraint.1.of, attribute: .lastBaseline, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .maxWidth:
                print("Max Width is not supported")
                break
            case .minWidth:
                print("Min Width is not supported")
                break
            case .maxHeight:
                print("Max Height is not supported")
                break
            case .minHeight:
                print("Min Height is not supported")
                break
            case .default:
                break
            }
        }
    }
    
    @available(*, deprecated: 1.1, message: "Use addConstraints(APConstraint...) instead")
    public func constrainUsing(constraints: [Constraint: (of: AnyObject?, offset: CGFloat)]) {
        var constraintDictionary : [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)] = [Constraint() : (nil, 0, 0)]
        for constraint in constraints {
            constraintDictionary[constraint.0] = (constraint.1.of, CGFloat(1), constraint.1.offset)
        }
        constrainUsing(constraints: constraintDictionary)
    }
    
    @available(*, deprecated: 1.1, message: "Use addConstraints(APConstraint...) instead")
    public func constrainUsing(constraints: [Constraint : AnyObject?]) {
        var constraintDictionary : [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)] = [Constraint() : (nil, 0, 0)]
        for constraint in constraints {
            constraintDictionary[constraint.0] = (constraint.1, 1.0, 0)
        }
        constrainUsing(constraints: constraintDictionary)
    }
    
    @available(*, deprecated: 1.1, message: "Use APStackView instead")
    public func spaceHorizontalWithInset(views: [UIView], inset: UIEdgeInsets) {
        assert(inset.right == inset.left, "Error! Left and Right insets must be equal")
        let parent = self
        parent.layoutIfNeeded()
        var totalWidthOfViews: CGFloat = 0
        for view in views as [UIView] {
            totalWidthOfViews += view.intrinsicContentSize.width
        }
        let padding = (parent.frame.width - totalWidthOfViews - (inset.right + inset.left)) / CGFloat(views.count)
        
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            parent.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: parent.frame.height))
            parent.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.intrinsicContentSize.width + padding))
            parent.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1.0, constant: inset.top))
            
            if view == views.first! {
                parent.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1.0, constant: inset.left))
            } else {
                parent.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: views[index - 1], attribute: .right, multiplier: 1.0, constant: 0))
            }
        }
    }
    
    // TODO: Finish this method another time, constraints for specific devices
//    @available(*, unavailable=1.1, message="Unifinished method")
//    public func constrainUsing(constraints constraints: [Constraint: (of: AnyObject?, offset: CGFloat)], forDevices devices: [DeviceTypes]) {
//        let currentDeviceType = UIDevice.currentDevice().deviceType
//        var currentDeviceSupported = false
//        for device in devices {
//            if currentDeviceType == device { currentDeviceSupported = true }
//        }
//        if !currentDeviceSupported { return }
//        var constraintDictionary : [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)] = [Constraint() : (nil, 0, 0)]
//        for constraint in constraints {
//            constraintDictionary[constraint.0] = (constraint.1.of, CGFloat(1), constraint.1.offset)
//        }
//        constrainUsing(constraints: constraintDictionary)
//    }
}
