//
//  DropdownConfiguration.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//

import Foundation
import UIKit

internal class PopoverConfiguration {
    
    static let shared = PopoverConfiguration()
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
