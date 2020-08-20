//
//  Dropdown+UIView.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

extension Dropdown where Base: UIView {
    
    func resetFrameAfterSet(anchorPoint: CGPoint) {
        let oldFrame = self.base.frame
        
        self.base.layer.anchorPoint = anchorPoint
        self.base.frame = oldFrame
    }
}
