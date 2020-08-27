//
//  UIImage+Drawing.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/19/20.
//

import UIKit

extension UIImage {
    
    func setBackground(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let view = UIView(frame: rect)
        
        let imageView = UIImageView(image: self)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = color
        
        view.addSubview(imageView)
        
        let size = rect.size
        UIGraphicsBeginImageContext(size)
        
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.cornerRadius = rect.size.width/2
            view.layer.masksToBounds = true
            //view.clipsToBounds = true
            view.layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        return nil
    }
}
