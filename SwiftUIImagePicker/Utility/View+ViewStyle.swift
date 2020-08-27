//
//  View+ViewStyle.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/19/20.
//

import SwiftUI

extension View {
    
    /// A modifier that adds StackNavigationViewStyle when device is phone and enable passed as true.
    ///
    /// In landscape orientation on iPhones that are big enough, iPhone 11 Pro Max for example,
    /// SwiftUI's default behavior is to show the secondary view and provide the primary as a
    /// slide over.
    ///
    /// - Parameter enable: Signals to use StackNavigationViewStyle only when idiom is phone.
    ///
    func phoneOnlyStackNavigationView(enable: Bool) -> some View {
        if enable && UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        }
        
        return AnyView(self)
    }
}
