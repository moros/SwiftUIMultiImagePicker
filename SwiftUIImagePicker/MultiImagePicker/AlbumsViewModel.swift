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
    
    @objc func albumsButtonPressed(_ sender: UIButton) {
        print("called")
        
        let controller = AlbumsViewController()
        controller.onDismiss = {
            self.rotateButtonArrow(sender)
        }
        controller.dropdown.enableDropdown = true
        controller.dropdown.presentationController?.sourceView = sender
        controller.dropdown.presentationController?.arrowPointX = self.navigationController?.navigationBar.frame.midX
        controller.dropdown.presentationController?.arrowPointY = (self.navigationController?.navigationBar.frame.height ?? CGFloat(0)) + CGFloat(44)
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
