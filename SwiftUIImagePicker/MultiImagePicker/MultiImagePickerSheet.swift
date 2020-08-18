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
            .navigationBarItems(
                leading:
                Button(action: {
                    print("Close clicked!")
                    self.isPresented = false
                }, label: {
                    Text("Close")
                }),
                trailing:
                Button(action: {
                    print("Done clicked!")
                    
                    self.isPresented = false
                    self.doneAction(self.selectedIds)
                }, label: {
                    Text("Done (\(selectedIds.count))").bold()
                }).disabled(selectedIds.count == 0)
            )
        }
    }
}

struct MultiImagePickerSheet_Previews: PreviewProvider {
    static var previews: some View {
        MultiImagePickerSheet(isPresented: .constant(true), doneAction: { _ in
        })
    }
}
