//
//  AlbumSettings.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/21/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import Photos

public class AlbumSettings: NSObject {

    public static let shared = AlbumSettings()
    internal override init() {
    }
    
    /// Fetch options for albums/collections
    ///
    public lazy var options: PHFetchOptions = {
        let fetchOptions = PHFetchOptions()
        return fetchOptions
    }()
    
    /// Fetch results for asset collections you want to present to the user
    /// Some other fetch results that you might wanna use:
    ///  - PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: options),
    ///  - PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options),
    ///  - PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: options),
    ///  - PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: options),
    ///  - PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: options),
    public lazy var fetchResults: [PHFetchResult<PHAssetCollection>] = [
        PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: options),
    ]
}
