//
//  AssetSelectablePreferenceKey.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

import SwiftUI

struct AssetSelectablePreferenceKey: PreferenceKey {
    static var defaultValue: [String]?
    
    static func reduce(value: inout [String]?, nextValue: () -> [String]?) {
        value = nextValue()
    }
}
