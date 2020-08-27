//
//  Popover+UIViewController.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/27/20.
//

import UIKit

private var _popoverPresentationControllerKey: UInt8 = 0
private var _popoverTransitioningDelegateKey: UInt8 = 0
private var _popoverIsNeedKey: UInt8 = 0

internal extension Popover where Base: UIViewController {
    
    var enablePopover: Bool {
        get {
            return (objc_getAssociatedObject(base, &_popoverIsNeedKey) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(base, &_popoverIsNeedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                base.modalPresentationStyle = .custom
                base.transitioningDelegate = base.popover.transitioningDelegate
            } else {
                base.modalPresentationStyle = .none
                base.transitioningDelegate = nil
            }
        }
    }
    
    var popoverPresentationController: PopoverPresentationController? {
        get {
            if let popover = objc_getAssociatedObject(base, &_popoverPresentationControllerKey) as? PopoverPresentationController {
                return popover
            }
            let popover = PopoverPresentationController(presentedViewController: base, presenting: nil)
            objc_setAssociatedObject(base, &_popoverPresentationControllerKey, popover, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return popover
        }
        set {
            objc_setAssociatedObject(base, &_popoverPresentationControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var transitioningDelegate: PopoverTransitionDelegate {
        if let transitioningDelegate = objc_getAssociatedObject(base, &_popoverTransitioningDelegateKey) as? PopoverTransitionDelegate {
            return transitioningDelegate
        }
        let transitioningDelegate = PopoverTransitionDelegate()
        objc_setAssociatedObject(base, &_popoverTransitioningDelegateKey, transitioningDelegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return transitioningDelegate
    }
}
