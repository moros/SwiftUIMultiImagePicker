//
//  MultiImagePickerSheet.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

import Introspect
import Photos
import SwiftUI
import UIKit

struct NavigationMultiImagePicker: View {
    @Binding var isPresented: Bool
    var doneAction: ([String]) -> ()
    
    private var albumButton: UIButton = UIButton(type: .system)
    @ObservedObject private var albumsViewModel = AlbumsViewModel()
    
    /// The PHAsset localIdentifier's selected by user.
    ///
    @State var selectedIds = [String]()
    
    /// The selected PHAssetCollection if so chooses to filter by album their list of photos.
    ///
    @State var selectedAssetCollection: PHAssetCollection? = nil
    
    /// Allows consuming code to turn on StackNavigationViewStyle
    /// especially if one does not wish to default to using a primary and secondary
    /// view as that is what SwiftUI will expect in landscape mode for
    /// certain iPhone devices.
    ///
    var usePhoneOnlyStackNavigation: Bool = false
    
    init(isPresented: Binding<Bool>, doneAction: @escaping ([String]) -> (), usePhoneOnlyStackNavigation: Bool = false) {
        self.doneAction = doneAction
        self._isPresented = isPresented
        self.usePhoneOnlyStackNavigation = usePhoneOnlyStackNavigation
    }
    
    var body: some View {
        NavigationView {
            MultiImagePicker(onSelected: { ids in
                self.selectedIds = ids
            }, selectedAssetCollection: self.$selectedAssetCollection, photosInRow: 4)
            
            // set title to empty string, to force proper nav layout; otherwise,
            // adding titleView through introspect adds extra space under it.
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: self.leadingButton(), trailing: self.trailingButton())
            .introspectNavigationController { navigationController in
                self.albumsViewModel.navigationController = navigationController
                self.albumButton.semanticContentAttribute = .forceRightToLeft
                self.albumButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                self.albumButton.setTitleColor(self.albumButton.tintColor, for: .normal)
                self.albumButton.setTitle("multi-imagepicker.nav.title.label".localized(), for: .normal)
                self.albumButton.addTarget(self.albumsViewModel, action: #selector(AlbumsViewModel.albumsButtonPressed(_:)), for: .touchUpInside)
                
                navigationController.viewControllers.first?.navigationItem.titleView = self.albumButton
            }
        }
        .phoneOnlyStackNavigationView(enable: self.usePhoneOnlyStackNavigation)
        .onReceive(self.albumsViewModel.objectWillChange, perform: { data in
            self.selectedIds = []
            self.selectedAssetCollection = data
        })
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
