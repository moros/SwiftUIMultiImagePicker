//
//  MultiImagePicker.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/18/20.
//

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
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let picker = ImagePickerViewController()
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(selectedIdentifiers: onSelected)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
