//
//  UIView+Helper.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/17/20.
//

import UIKit

extension UIView {
    func constraintsToFill(otherView: Any) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: otherView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: otherView, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: otherView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: otherView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ]
    }
    
    func constraintEqualTo(with otherView: Any, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: otherView, attribute: attribute, multiplier: 1.0, constant: constant)
    }
}
