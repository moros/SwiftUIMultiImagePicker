//
//  MultiImagePickerSheet.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

import SwiftUI

struct NavigationMultiImagePicker: View {
    @Binding var isPresented: Bool
    @State var doneAction: ([String]) -> ()
    
    /// The PHAsset localIdentifier's selected by user.
    ///
    @State var selectedIds = [String]()
    
    /// Allows consuming code to turn on StackNavigationViewStyle
    /// especially if one does not wish to default to using a primary and secondary
    /// view as that is what SwiftUI will expect in landscape mode for
    /// certain iPhone devices.
    ///
    var usePhoneOnlyStackNavigation: Bool = false
    
    var body: some View {
        NavigationView {
            MultiImagePicker(onSelected: { ids in
                self.selectedIds = ids
            })
            .navigationBarTitle("multi-imagepicker.nav.title.label", displayMode: .inline)
            .navigationBarItems(leading: self.leadingButton(), trailing: self.trailingButton())
        }
        .phoneOnlyStackNavigationView(enable: self.usePhoneOnlyStackNavigation)
    }
    
    private func leadingButton() -> some View {
        return Button(action: {
            self.isPresented = false
        }, label: {
            Text("cancel.label".localized())
        })
    }
    
    private func trailingButton() -> some View {
        return Button(action: {
            self.isPresented = false
            self.doneAction(self.selectedIds)
        }, label: {
            Text("done.count.label".localized(withArguments: selectedIds.count)).bold()
        }).disabled(selectedIds.count == 0)
    }
}

#if DEBUG
struct MultiImagePickerSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMultiImagePicker(isPresented: .constant(true), doneAction: { _ in
        })
    }
}
#endif
