//
//  Dropdown+UIViewController.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

private var dropdownPresentationControllerKey: UInt8 = 0
private var transitioningDelegateKey: UInt8 = 0
private var isNeedDropdownKey: UInt8 = 0

extension Dropdown where Base: UIViewController {
    
    public var enableDropdown: Bool {
        set {
            objc_setAssociatedObject(base, &isNeedDropdownKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                base.modalPresentationStyle = .custom
                base.transitioningDelegate = base.dropdown.transitioningDelegate
            } else {
                base.modalPresentationStyle = .none
                base.transitioningDelegate = nil
            }
        } get {
            return (objc_getAssociatedObject(base, &isNeedDropdownKey) as? Bool) ?? false
        }
    }
    
    public var presentationController: DropdownPresentationController? {
        set {
            objc_setAssociatedObject(base, &dropdownPresentationControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let dropdown = objc_getAssociatedObject(base, &dropdownPresentationControllerKey) as? DropdownPresentationController {
                return dropdown
            }
            let dropdown = DropdownPresentationController(presentedViewController: base, presenting: nil)
            objc_setAssociatedObject(base, &dropdownPresentationControllerKey, dropdown, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return dropdown
        }
    }
    
    public var transitioningDelegate: DropdownTransitionDelegate {
        if let transitioningDelegate = objc_getAssociatedObject(base, &transitioningDelegateKey) as? DropdownTransitionDelegate {
            return transitioningDelegate
        }
        let transitioningDelegate = DropdownTransitionDelegate()
        objc_setAssociatedObject(base, &transitioningDelegateKey, transitioningDelegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return transitioningDelegate
    }
}
