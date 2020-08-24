//
//  DropdownConfiguration.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

class DropdownConfiguration {
    
    static let shared = DropdownConfiguration()
    private init() {
    }
    
    enum Animation {
        case scale
        case alpha
    }
    
    var arrowSize = CGSize(width: 12, height: 7)
    var cornerRadius = CGFloat(10)
    var animationDuration = TimeInterval(0.25)
    var backgroundColor = UIColor.white
    var dimmingViewColor = UIColor.black.withAlphaComponent(0.35)
    var showDimmingView = true
    var animation: Animation = .scale
}
