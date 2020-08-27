//
//  Dropdown+UIView.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//

import Foundation
import UIKit

internal extension Popover where Base: UIView {
    
    func resetFrameAfterSet(anchorPoint: CGPoint) {
        let oldFrame = self.base.frame
        
        self.base.layer.anchorPoint = anchorPoint
        self.base.frame = oldFrame
    }
}
