//
//  AlbumsViewControllerDelegate.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/24/20.
//

import Foundation
import Photos

internal protocol AlbumsViewControllerDelegate: class {
    
    /// Informs listener of `PHAssetCollection` that was selected by the user.
    ///
    /// - Parameter viewController: the `AlbumsViewController`
    /// - Parameter album: `PHAssetCollection` selected
    ///
    func albumsViewController(_ viewController: AlbumsViewController, didSelectAlbum album: PHAssetCollection)
}
