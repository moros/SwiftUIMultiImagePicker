//
//  DropdownCompatible.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//

import Foundation
import UIKit

internal final class Popover<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

internal protocol PopoverProtocol {
    associatedtype PopoverType
    
    var popover: PopoverType { get }
}

internal extension PopoverProtocol {
    
    var popover: Popover<Self> {
        get {
            return Popover(self)
        }
    }
}

extension UIViewController: PopoverProtocol { }
extension UIView: PopoverProtocol { }
