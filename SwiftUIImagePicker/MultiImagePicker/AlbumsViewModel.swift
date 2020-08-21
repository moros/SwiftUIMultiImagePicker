//
//  AlbumsViewModel.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

public class AlbumsViewModel: NSObject {
    
    var navigationController: UINavigationController? = nil
    private var transitionDelegate: DropdownTransitionDelegate? = nil
    
    var isLandscape: Bool {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    }
    
    @objc func albumsButtonPressed(_ sender: UIButton) {

        let controller = AlbumsViewController()        
        controller.onDismiss = {
            self.rotateButtonArrow(sender)
        }
        
        let delegate = DropdownTransitionDelegate()
        
        let window: UIWindow? = UIApplication.shared.windows.first
        delegate.sourceView = sender
        delegate.sourceRect = sender.convert(sender.bounds, to: window)
        self.transitionDelegate = delegate
        
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self.transitionDelegate
        
        let frame = window?.frame ?? CGRect.zero
        let height = frame.height * (self.isLandscape ? 0.75 : 0.5)
        controller.preferredContentSize = CGSize(width: frame.width * 0.75, height: height)
        rotateButtonArrow(sender)
        
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    private func rotateButtonArrow(_ button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            guard let imageView = button.imageView else {
                return
            }
            
            imageView.transform = imageView.transform.rotated(by: .pi)
        }
    }
}
