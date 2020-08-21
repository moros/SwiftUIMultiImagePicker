//
//  AlbumsViewModel.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import UIKit

public class AlbumsViewModel: NSObject {
    
    var navigationController: UINavigationController? = nil
    private var transitionDelegate: DropdownTransitionDelegate? = nil
    
    @objc func albumsButtonPressed(_ sender: UIButton) {

        let controller = AlbumsViewController()        
        controller.onDismiss = {
            self.rotateButtonArrow(sender)
        }
        
        let delegate = DropdownTransitionDelegate()
        delegate.sourceView = sender
        delegate.sourceRect = sender.convert(sender.bounds, to: UIApplication.shared.windows.first)
        self.transitionDelegate = delegate
        
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self.transitionDelegate
        controller.preferredContentSize = CGSize(width: 200, height: 400)
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
