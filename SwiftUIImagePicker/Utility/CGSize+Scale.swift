//
//  CGSize+Scale.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/21/20.
//

import UIKit

extension CGSize {
    func resize(by scale: CGFloat) -> CGSize {
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}
