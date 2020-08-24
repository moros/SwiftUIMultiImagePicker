//
//  DropdownTransitionDelegate.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

public class DropdownTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private let arrowDirection: DropdownPresentationController.ArrowDirection
    private let configuration: DropdownConfiguration
    
    var sourceView: UIView?
    var sourceRect: CGRect = CGRect.zero
    var sourceBarButtonItem: UIBarButtonItem?
    var arrowPointX: CGFloat? = nil
    var arrowPointY: CGFloat? = nil
    
    init(arrowDirection: DropdownPresentationController.ArrowDirection = .up,
         configuration: DropdownConfiguration = DropdownConfiguration.shared) {
        self.arrowDirection = arrowDirection
        self.configuration = configuration
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = DropdownPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.arrowDirection = self.arrowDirection
        presentation.configuration = self.configuration
        presentation.sourceView = self.sourceView
        presentation.sourceRect = self.sourceRect
        presentation.barButtonItem = self.sourceBarButtonItem
        presentation.arrowPointX = self.arrowPointX
        presentation.arrowPointY = self.arrowPointY
        
        return presentation
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropdownAnimator(context: .present, animation: .scale)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropdownAnimator(context: .dismiss, animation: .scale)
    }
}
