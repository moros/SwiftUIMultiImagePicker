//
//  DropdownTransitionDelegate.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//

import Foundation
import UIKit

internal class PopoverTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presented.popover.popoverPresentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverAnimator(context: .present, animation: .scale)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverAnimator(context: .dismiss, animation: .scale)
    }
}
