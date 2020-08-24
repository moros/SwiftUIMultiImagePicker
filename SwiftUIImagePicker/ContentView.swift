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
    
    /// The selected PHAssetCollection if so chooses to filter by album their list of photos.
    ///
    @State var selectedAssetCollection: PHAssetCollection? = nil
    
    var body: some View {
//        NavigationMultiImagePicker(isPresented: self.$sheetPickerShown, doneAction: { _ in
//
//        }, usePhoneOnlyStackNavigation: true)
        VStack {
            MultiImagePicker(onSelected: { ids in
                print(ids)
            }, selectedAssetCollection: self.$selectedAssetCollection, photosInRow: 4)
            Button(action: {
                self.sheetPickerShown = true
            }) {
                Text("Show Sheet Image Picker")
            }
            .sheet(isPresented: self.$sheetPickerShown, content: {
                NavigationMultiImagePicker(isPresented: self.$sheetPickerShown, doneAction: { ids in
                    print("ids from nav picker: \(ids)")
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
