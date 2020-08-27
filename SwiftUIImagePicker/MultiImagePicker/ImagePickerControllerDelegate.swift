//
//  ImagePickerControllerDelegate.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/17/20.
//

import Photos
import UIKit

@objc internal protocol ImagePickerControllerDelegate: class {
    
    /// Provides an array of `PHAsset`s selected.
    ///
    /// - Parameter picker: the `ImagePickerViewController`
    /// - Parameter identifiers: the array of `PHAsset.localIdentifier` strings.
    ///
    @objc optional func imagePicker(_ picker: ImagePickerViewController, didPickAssetIdentifiers identifiers: [String])
}
