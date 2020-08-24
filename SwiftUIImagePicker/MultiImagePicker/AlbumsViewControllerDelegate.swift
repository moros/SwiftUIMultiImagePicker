//
//  AlbumsViewControllerDelegate.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/24/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import Photos

protocol AlbumsViewControllerDelegate: class {
    func albumsViewController(_ viewController: AlbumsViewController, didSelectAlbum ablum: PHAssetCollection)
}
