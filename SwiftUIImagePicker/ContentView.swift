//
//  ContentView.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var sheetPickerShown = false
    
    var body: some View {
        VStack {
            MultiImagePicker(onSelected: { ids in
                print(ids)
            }, photosInRow: 4)
            Button(action: {
                self.sheetPickerShown = true
            }) {
                Text("Show Sheet Image Picker")
            }
            .sheet(isPresented: self.$sheetPickerShown, content: {
                NavigationMultiImagePicker(isPresented: self.$sheetPickerShown, doneAction: { _ in
                    
                }, usePhoneOnlyStackNavigation: true)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
