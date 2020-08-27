//
//  DropdownAnimator.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//

import Foundation
import UIKit

internal class PopoverAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum AnimationContext {
        case present
        case dismiss
    }
    
    private let context: AnimationContext
    fileprivate var presentationController: PopoverPresentationController?
    fileprivate let animation: PopoverConfiguration.Animation
    
    init(context: AnimationContext, animation: PopoverConfiguration.Animation) {
        self.context = context
        self.animation = animation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // determine if our context is being to present
        let presenting = self.context == .present
        
        guard let source = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        guard let destination = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let container = transitionContext.containerView
        
        // take destination view snapshot
        // use true because the view hasn't been rendered yet.
        guard let destinationSnapshot = destination.view.snapshotView(afterScreenUpdates: true) else {
            return
        }
        
        let startAlpha: CGFloat = presenting ? 0 : 1
        let endAlpha: CGFloat = presenting ? 1 : 0
        
        
        // add snapshot view if presenting
        if presenting {
            destinationSnapshot.alpha = startAlpha
            destinationSnapshot.frame = destination.view.frame
            
            container.addSubview(destinationSnapshot)
        } else {
            destinationSnapshot.alpha = endAlpha
            source.view.removeFromSuperview()
        }
        
        // move destination snapshot back in Z plane
        var perspectiveTransform = CATransform3DIdentity
        perspectiveTransform.m34 = 1.0 / -1000.0
        perspectiveTransform = CATransform3DTranslate(perspectiveTransform, 0, -destinationSnapshot.frame.height, -100)
        destinationSnapshot.layer.transform = perspectiveTransform

        // start appearance transition for source controller
        // because UIKit does not remove views from hierarchy when transition finished
        source.beginAppearanceTransition(false, animated: true)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8, animations: {
                destinationSnapshot.layer.transform = CATransform3DIdentity
            })
        }, completion: { finished in
            destinationSnapshot.alpha = endAlpha
            
            // remove destination snapshot
            destinationSnapshot.removeFromSuperview()
            
            // add destination controller to view
            if presenting {
                container.addSubview(destination.view)
            }
            
            // finish transition
            transitionContext.completeTransition(finished)
            
            // end appearance transition for source controller
            source.endAppearanceTransition()
        })
    }
}
