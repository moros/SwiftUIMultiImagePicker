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
        NavigationView {
            VStack {
                NavigationLink(destination: MultiImagePicker(onSelected: { ids in
                    print(ids)
                }, photosInRow: 4), label: {
                    Text("Show ImagePicker from Nav Link")
                        .font(.headline)
                        .padding()
                })
                
                Button(action: {
                    self.sheetPickerShown = true
                }) {
                    Text("Show ImagePicker in sheet")
                        .font(.headline)
                        .padding()
                }
                .sheet(isPresented: self.$sheetPickerShown, content: {
                    MultiImagePicker(isPresented: self.$sheetPickerShown, onSelected: { ids in
                        print("ids from nav picker: \(ids)")
                    }, usePhoneOnlyStackNavigation: true, wrapViewInNavigationView: true)
                })
            }
            .navigationBarTitle("Image Picker")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
