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

class ImagePickerCordinator: NSObject, ImagePickerControllerDelegate {
    
    let selectedIdentifiers: AssetIdentifiersSelected
    
    init(selectedIdentifiers: @escaping AssetIdentifiersSelected) {
        self.selectedIdentifiers = selectedIdentifiers
    }
    
    func imagePicker(_ picker: ImagePickerViewController, didPickAssetIdentifiers identifiers: [String]) {
        self.selectedIdentifiers(identifiers)
    }
}

struct MultiImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImagePickerViewController
    let onSelected: AssetIdentifiersSelected
    
    /// Maximum photo selections allowed in picker
    ///
    var maximumSelectionsAllowed: Int = -1
    
    /// Defends number of photos to put into each row.
    ///
    var photosInRow: Int = 3
    
    /// Minimum amount of spacing between images.
    ///
    var imageMinimumInteritemSpacing: CGFloat = 6
    
    /// The selected PHAssetCollection if so chooses to filter by album their list of photos.
    ///
    @Binding var selectedAssetCollection: PHAssetCollection?
    
    init(onSelected: @escaping AssetIdentifiersSelected, selectedAssetCollection: Binding<PHAssetCollection?>, maximumSelectionsAllowed: Int = -1, photosInRow: Int = 3, imageMinimumInteritemSpacing: CGFloat = 6) {
        self.onSelected = onSelected
        self._selectedAssetCollection = selectedAssetCollection
        
        self.maximumSelectionsAllowed = maximumSelectionsAllowed
        self.photosInRow = photosInRow
        self.imageMinimumInteritemSpacing = imageMinimumInteritemSpacing
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let picker = ImagePickerViewController()
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
        if self.selectedAssetCollection != uiViewController.selectedAssetCollection {
            uiViewController.selectedAssetCollection = self.selectedAssetCollection
        }
    }
}
