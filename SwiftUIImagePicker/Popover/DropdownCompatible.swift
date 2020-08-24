//
//  DropdownCompatible.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

public final class Dropdown<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DropdownCompatible {
    associatedtype DropdownCompatibleType
    
    var dropdown: DropdownCompatibleType { get }
}

public extension DropdownCompatible {
    
    var dropdown: Dropdown<Self> {
        get {
            return Dropdown(self)
        }
    }
}

extension UIViewController: DropdownCompatible { }
extension UIView: DropdownCompatible { }
