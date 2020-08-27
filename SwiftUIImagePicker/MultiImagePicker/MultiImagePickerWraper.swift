//
//  MultiImagePicker.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

import Combine
import Photos
import SwiftUI
import UIKit

internal typealias AssetIdentifiersSelected = ([String]) -> Void

internal struct MultiImagePickerWrapper: UIViewControllerRepresentable {
    
    /// The type associated with this representable.
    ///
    typealias UIViewControllerType = ImagePickerViewController
    
    /// Callback when asset identifiers are selected.
    ///
    let onSelected: AssetIdentifiersSelected
    
    /// Maximum photo selections allowed in picker
    ///
    var maximumSelectionsAllowed: Int = -1
    
    /// Default number of photos to put into each row.
    ///
    var photosInRow: Int = 4
    
    /// Minimum amount of spacing between images.
    ///
    var imageMinimumInteritemSpacing: CGFloat = 6
    
    /// ViewModel for Albums so that the underlying image picker view controller can be notified
    /// when user selects a particular album.
    ///
    private var albumsViewModel: AlbumsViewModel
    
    init(albumsViewModel: AlbumsViewModel, onSelected: @escaping AssetIdentifiersSelected, maximumSelectionsAllowed: Int = -1, photosInRow: Int = 3, imageMinimumInteritemSpacing: CGFloat = 6) {
        self.albumsViewModel = albumsViewModel
        self.onSelected = onSelected
        self.maximumSelectionsAllowed = maximumSelectionsAllowed
        self.photosInRow = photosInRow
        self.imageMinimumInteritemSpacing = imageMinimumInteritemSpacing
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let picker = ImagePickerViewController()
        picker.albumsViewModel = self.albumsViewModel
        picker.delegate = context.coordinator
        picker.maximumSelectionsAllowed = self.maximumSelectionsAllowed
        picker.numberOfPhotosInRow = self.photosInRow
        picker.imageMinimumInteritemSpacing = self.imageMinimumInteritemSpacing
        
        return picker
    }
    
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(selectedIdentifiers: onSelected)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    internal class ImagePickerCordinator: NSObject, ImagePickerControllerDelegate {
        
        let selectedIdentifiers: AssetIdentifiersSelected
        
        init(selectedIdentifiers: @escaping AssetIdentifiersSelected) {
            self.selectedIdentifiers = selectedIdentifiers
        }
        
        func imagePicker(_ picker: ImagePickerViewController, didPickAssetIdentifiers identifiers: [String]) {
            self.selectedIdentifiers(identifiers)
        }
    }
}
