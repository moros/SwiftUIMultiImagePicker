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

/// An image picker that shows and allows multiple selection of photos
/// using the Photos library.
///
public struct MultiImagePicker: View {
    
    /// Used for triggering re-render of view.
    ///
    @Binding var isPresented: Bool
    
    /// Triggered when a user taps done button from navigation bar if
    /// picker is embedded in a navigation view.
    ///
    var onSelected: ([String]) -> ()
    
    /// Allows consuming code to turn on StackNavigationViewStyle
    /// especially if one does not wish to default to using a primary and secondary
    /// view as that is what SwiftUI will expect in landscape mode for
    /// certain iPhone devices.
    ///
    var usePhoneOnlyStackNavigation: Bool = false
    
    /// Indication if view should be wrapped in a navigation view.
    /// Most useful if displaying said view as a sheet.
    ///
    var wrapViewInNavigationView: Bool = false
    
    /// Default number of photos to put into each row.
    ///
    var photosInRow: Int = 4
    
    /// Model object for getting `PHAssetCollection`s and selecting one.
    ///
    private var albumsViewModel: AlbumsViewModel
    
    /// The PHAsset localIdentifier's selected by user.
    ///
    @State private var selectedIds = [String]()
    
    /// The selected PHAssetCollection if so chooses to filter by album their list of photos.
    ///
    @State private var selectedAssetCollection: PHAssetCollection? = nil
    
    init(isPresented: Binding<Bool> = .constant(true), onSelected: @escaping ([String]) -> (), usePhoneOnlyStackNavigation: Bool = false, wrapViewInNavigationView: Bool = false, photosInRow: Int = 4) {
        self.albumsViewModel = AlbumsViewModel()
        self._isPresented = isPresented
        self.onSelected = onSelected
        self.usePhoneOnlyStackNavigation = usePhoneOnlyStackNavigation
        self.wrapViewInNavigationView = wrapViewInNavigationView
        self.photosInRow = photosInRow
    }
    
    public var body: some View {
        if !self.wrapViewInNavigationView {
            return AnyView(self.makePickerView())
        }
        
        return AnyView(NavigationView {
            self.makePickerView()
        })
    }
    
    private func makePickerView() -> some View {
        return MultiImagePickerWrapper(albumsViewModel: self.albumsViewModel, onSelected: { ids in
            self.selectedIds = ids
        }, photosInRow: self.photosInRow)
        
        // set title to empty string, to force proper nav layout; otherwise,
        // adding titleView through introspect adds extra space under it.
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: self.leadingButton(), trailing: self.trailingButton())
        .introspectNavigationController { navigationController in
            self.albumsViewModel.navigationController = navigationController
            
            let albumButton = UIButton(type: .system)
            albumButton.semanticContentAttribute = .forceRightToLeft
            albumButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            albumButton.setTitleColor(albumButton.tintColor, for: .normal)
            albumButton.setTitle("multi-imagepicker.nav.title.label".localized(), for: .normal)
            albumButton.addTarget(self.albumsViewModel, action: #selector(AlbumsViewModel.albumsButtonPressed(_:)), for: .touchUpInside)
            
            navigationController.viewControllers.first?.navigationItem.titleView = albumButton
        }
        .phoneOnlyStackNavigationView(enable: self.usePhoneOnlyStackNavigation)
        .onDisappear {
            
            // when picker disappears either canceled tapped or view popped from navigation view
            // resetting selectedAssetCollection so next time in, the photos listed and the album
            // selected are NOT out of sync.
            self.albumsViewModel.selectedAssetCollection = nil
        }
    }
    
    private func leadingButton() -> some View {
        if !self.wrapViewInNavigationView {
            return AnyView(EmptyView())
        }
        
        return AnyView(Button(action: {
            self.isPresented = false
        }, label: {
            Text("cancel.label".localized())
        }))
    }
    
    private func trailingButton() -> some View {
        return Button(action: {
            self.isPresented = false
            self.onSelected(self.selectedIds)
        }, label: {
            Text("done.count.label".localized(withArguments: selectedIds.count)).bold()
        }).disabled(selectedIds.count == 0)
    }
}

#if DEBUG
struct MultiImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        MultiImagePicker(isPresented: .constant(true), onSelected: { _ in
        })
    }
}
#endif
