//
//  DropdownPresentationController.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

public class DropdownPresentationController: UIPresentationController {
    
    public enum ArrowDirection {
        case up
        case left
        case right
        case down
    }
    
    fileprivate(set) var anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
    fileprivate let backgroundView = DropdownBackgroundView()
    fileprivate var backgroundViewRect = CGRect.zero
    fileprivate var arrowPoint = CGPoint.zero
    var configuration = DropdownConfiguration.shared {
        didSet {
            self.backgroundView.configuration = configuration
        }
    }
    
    public var sourceView: UIView?
    public var sourceRect: CGRect = CGRect.zero
    public var barButtonItem: UIBarButtonItem?
    
    public var arrowPointX: CGFloat? = nil
    public var arrowPointY: CGFloat? = nil
    public var layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    public var arrowDirection = ArrowDirection.up {
        didSet {
            self.backgroundView.arrowDirection = arrowDirection
        }
    }
    
    fileprivate lazy var dimmingView: UIView = { [unowned self] in
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:)))
        let dimmingView = UIView()
        
        dimmingView.backgroundColor = self.configuration.dimmingViewColor
        dimmingView.addGestureRecognizer(gesture)
        
        if !self.configuration.showDimmingView {
            dimmingView.backgroundColor = UIColor.clear
        }
        
        return dimmingView
    }()
    
    @objc func dimmingViewTapped(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    override open var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override open var adaptivePresentationStyle: UIModalPresentationStyle {
        return .overFullScreen
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        
        var frame = CGRect.zero
        if let containerView = self.containerView {
            var newRect: CGRect
            
            let containerSize = containerView.bounds.size
            frame.size = self.size(
                forChildContentContainer: self.presentedViewController,
                withParentContainerSize: containerSize
            )
            
            if let sourceView = sourceView {
                newRect = CGRect(
                    x: self.sourceRect.origin.x + sourceView.frame.origin.x,
                    y: self.sourceRect.origin.y + sourceView.frame.origin.y,
                    width: self.sourceRect.width,
                    height: self.sourceRect.height
                )
            } else if let barButtonItem = barButtonItem {
                if let view = barButtonItem.value(forKey: "view") as? UIView {
                    newRect = containerView.convert(view.frame, from: view.superview)
                } else {
                    newRect = CGRect.zero
                }
            } else {
                fatalError("Unable to compute CGRect for dropdown.")
            }
            
            if let arrowPointX = self.arrowPointX {
                newRect.origin.x = arrowPointX
                newRect.size.width = 0
            }
            
            if let arrowPointY = self.arrowPointY {
                newRect.origin.y = arrowPointY
                newRect.size.height = 0
            }
            
            func computeX() -> CGFloat {
                var x = newRect.midX - frame.midX
                if x < 0 {
                    x = self.layoutMargins.left
                } else if x > containerSize.width - frame.width {
                    x = containerSize.width - self.layoutMargins.right - frame.width
                }
                
                return x
            }
            
            func computeY() -> CGFloat {
                var y = newRect.midY - frame.midY
                if y < 0 {
                    y = self.layoutMargins.top
                } else if y > containerSize.height - frame.height {
                    y = containerSize.height - self.layoutMargins.bottom - frame.height
                }
                
                return y
            }
            
            var x: CGFloat = 0
            var y: CGFloat = 0
            let arrowPoint: CGPoint
            let triangleHeight = self.configuration.arrowSize.height
            let cornerRadius = self.configuration.cornerRadius
            let backgroundViewWidth = frame.width + triangleHeight + cornerRadius * 2
            let backgroundViewHeight = frame.height + triangleHeight
            
            switch self.arrowDirection {
            case .up:
                x = computeX()
                y = newRect.maxY + triangleHeight
                arrowPoint = CGPoint(x: newRect.midX, y: newRect.maxY)
            case .left:
                x = newRect.maxX + triangleHeight + cornerRadius
                y = computeY()
                arrowPoint = CGPoint(x: newRect.maxX, y: newRect.midY)
            case .down:
                x = computeX()
                y = newRect.minY - backgroundViewHeight + cornerRadius
                arrowPoint = CGPoint(x: newRect.midX, y: newRect.minY)
            case .right:
                x = newRect.minX - backgroundViewWidth + cornerRadius
                y = computeY()
                arrowPoint = CGPoint(x: newRect.minX, y: newRect.midY)
            }
            
            frame.origin.x = x
            frame.origin.y = y
            self.arrowPoint = arrowPoint
            
            switch self.arrowDirection {
            case .up:
                self.backgroundViewRect = CGRect(
                    x: x,
                    y: y - triangleHeight,
                    width: frame.width,
                    height: backgroundViewHeight
                )
            case .down:
                self.backgroundViewRect = CGRect(
                    x: x,
                    y: y - cornerRadius,
                    width: frame.width,
                    height: backgroundViewHeight
                )
            case .left:
                self.backgroundViewRect = CGRect(
                    x: x - triangleHeight - cornerRadius,
                    y: y,
                    width: backgroundViewWidth,
                    height: frame.height
                )
            case .right:
                self.backgroundViewRect = CGRect(
                    x: x - cornerRadius,
                    y: y,
                    width: backgroundViewWidth,
                    height: frame.height
                )
            }
        }
        
        return frame
    }
    
    public override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
             return
        }
        
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0
        
        self.backgroundView.arrowColor = self.traitCollection.userInterfaceStyle == .light ? UIColor.white : UIColor.systemGroupedBackground
        
        containerView.insertSubview(backgroundView, at: 0)
        containerView.insertSubview(dimmingView, at: 0)
        
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = backgroundViewRect
        presentedView?.layer.cornerRadius = self.configuration.cornerRadius
        
        let converArrowPoint = containerView.convert(arrowPoint, to: backgroundView)
        backgroundView.arrowPoint = converArrowPoint
         
        let anchorPoint: CGPoint
        switch arrowDirection {
        case .up:
            anchorPoint = CGPoint(x: converArrowPoint.x / backgroundView.frame.width, y: 0)
        case .down:
            anchorPoint = CGPoint(x: converArrowPoint.x / backgroundView.frame.width, y: 1)
        case .left:
            anchorPoint = CGPoint(x: 0, y: converArrowPoint.y / backgroundView.frame.height)
        case .right:
            anchorPoint = CGPoint(x: 1, y: converArrowPoint.y / backgroundView.frame.height)
        }
         
        backgroundView.dropdown.resetFrameAfterSet(anchorPoint: anchorPoint)
        self.anchorPoint = anchorPoint
        switch self.configuration.animation {
        case .scale:
            backgroundView.transform = CGAffineTransform(scaleX: 0, y: 0)
        case .alpha:
            backgroundView.alpha = 0
        }
         
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
            self.backgroundView.transform = CGAffineTransform.identity
            self.backgroundView.alpha = 1
        }, completion: nil)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            self.backgroundView.frame = self.backgroundViewRect
        }, completion: nil)
    }
    
    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
    }
    
    public override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0
            switch self.configuration.animation {
            case .scale:
                self.backgroundView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            case .alpha:
                self.backgroundView.alpha = 0
            }

        }, completion: nil)
    }
    
    public override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        guard container.preferredContentSize != CGSize.zero else {
            return parentSize
        }
        
        return container.preferredContentSize
    }
}
