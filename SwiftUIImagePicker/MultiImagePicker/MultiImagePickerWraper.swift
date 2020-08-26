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

typealias AssetIdentifiersSelected = ([String]) -> Void

internal class ImagePickerCordinator: NSObject, ImagePickerControllerDelegate {
    
    let selectedIdentifiers: AssetIdentifiersSelected
    
    init(selectedIdentifiers: @escaping AssetIdentifiersSelected) {
        self.selectedIdentifiers = selectedIdentifiers
    }
    
    func imagePicker(_ picker: ImagePickerViewController, didPickAssetIdentifiers identifiers: [String]) {
        self.selectedIdentifiers(identifiers)
    }
}

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
    
    /// The selected PHAssetCollection if so chooses to filter by album their list of photos.
    ///
    @Binding var selectedAssetCollection: PHAssetCollection?
    
    var viewModel: AlbumsViewModel
    
    init(viewModel: AlbumsViewModel, onSelected: @escaping AssetIdentifiersSelected, selectedAssetCollection: Binding<PHAssetCollection?>, maximumSelectionsAllowed: Int = -1, photosInRow: Int = 3, imageMinimumInteritemSpacing: CGFloat = 6) {
        self.viewModel = viewModel
        self.onSelected = onSelected
        self._selectedAssetCollection = selectedAssetCollection
        
        self.maximumSelectionsAllowed = maximumSelectionsAllowed
        self.photosInRow = photosInRow
        self.imageMinimumInteritemSpacing = imageMinimumInteritemSpacing
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let picker = ImagePickerViewController()
        picker.viewModel = self.viewModel
        picker.delegate = context.coordinator
        picker.maximumSelectionsAllowed = self.maximumSelectionsAllowed
        picker.numberOfPhotosInRow = self.photosInRow
        picker.imageMinimumInteritemSpacing = self.imageMinimumInteritemSpacing
        picker.selectedAssetCollection = self.selectedAssetCollection
        
        return picker
    }
    
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(selectedIdentifiers: onSelected)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
