//
//  ContentView.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

import Combine
import Photos
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
                MultiImagePicker(isPresented: self.$sheetPickerShown, onSelected: { ids in
                    print("ids from nav picker: \(ids)")
                }, usePhoneOnlyStackNavigation: true, wrapViewInNavigationView: true)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
