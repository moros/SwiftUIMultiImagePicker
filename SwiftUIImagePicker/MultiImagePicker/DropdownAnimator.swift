//
//  DropdownAnimator.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

class DropdownAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum AnimationContext {
        case present
        case dismiss
    }
    
    private let context: AnimationContext
    fileprivate var presentationController: DropdownPresentationController?
    fileprivate let animation: DropdownConfiguration.Animation
    
    init(context: AnimationContext, animation: DropdownConfiguration.Animation) {
        self.context = context
        self.animation = animation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presenting = self.context == .present
        
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        guard let fromView = fromVC.view, let toView = toVC.view else {
            return
        }
        
        let containerView = transitionContext.containerView
        if presenting {
            containerView.addSubview(toView)
        }
        
        let animatingView = presenting ? toView : fromView
        let animatingVC = presenting ? toVC : fromVC
        
//        if let anchorPoint = animatingVC.dropdown.presentationController?.anchorPoint {
//            self.presentationController = animatingVC.dropdown.presentationController
//            animatingView.dropdown.resetFrameAfterSet(anchorPoint: anchorPoint)
//        }
        
        let startScale: CGFloat = presenting ? 0 : 1
        let endScale: CGFloat = presenting ? 1 : 0.1
        let startAlpha: CGFloat = presenting ? 0 : 1
        let endAlpha: CGFloat = presenting ? 1 : 0.1
        switch self.animation {
        case .scale:
            animatingView.transform = CGAffineTransform(scaleX: startScale, y: startScale)
        case .alpha:
            animatingView.alpha = startAlpha
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            switch self.animation {
            case .scale:
                if presenting {
                    animatingView.transform = CGAffineTransform.identity
                } else {
                    animatingView.transform = CGAffineTransform(scaleX: endScale, y: endScale)
                }
            case .alpha:
                animatingView.alpha = endAlpha
            }
        }) { (finished) in
            if !presenting {
                fromView.removeFromSuperview()
//                animatingVC.dropdown.presentationController = nil
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
