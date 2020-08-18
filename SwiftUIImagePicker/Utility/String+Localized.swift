//
//  String+Localized.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

import Foundation

extension String {
    public func localized(withComment comment: String? = nil) -> String {
        NSLocalizedString(self, comment: comment ?? "")
    }
    
    public func localized(_ args: CVarArg..., withComment comment: String? = nil) -> String {
        let localizedStr = NSLocalizedString(self, comment: comment ?? "")
        return String(format: localizedStr, args)
    }
}
