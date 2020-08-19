//
//  MultiImagePickerSheet.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

import SwiftUI

struct MultiImagePickerSheet: View {
    @Binding var isPresented: Bool
    @State var doneAction: ([String]) -> ()
    @State var selectedIds = [String]()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                MultiImagePicker(onSelected: { ids in
                    self.selectedIds = ids
                })
            }
            .navigationBarTitle("Photos", displayMode: .inline)
            .navigationBarItems(leading: self.leadingButton(), trailing: self.trailingButton())
        }
    }
    
    private func leadingButton() -> some View {
        return Button(action: {
            self.isPresented = false
        }, label: {
            Text("Close")
        })
    }
    
    private func trailingButton() -> some View {
        return Button(action: {
            self.isPresented = false
            self.doneAction(self.selectedIds)
        }, label: {
            Text("Done (\(selectedIds.count))").bold()
        }).disabled(selectedIds.count == 0)
    }
}

#if DEBUG
struct MultiImagePickerSheet_Previews: PreviewProvider {
    static var previews: some View {
        MultiImagePickerSheet(isPresented: .constant(true), doneAction: { _ in
        })
    }
}
#endif
