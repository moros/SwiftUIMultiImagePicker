//
//  AlbumsTableViewDataSource.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/24/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import Photos
import UIKit

class AlbumsTableViewDataSource: NSObject, UITableViewDataSource {
    
    var assetSettings: AssetSettings = AssetSettings.shared
    private var selectedAssetCollection: PHAssetCollection? = nil
    private let albums: [PHAssetCollection]
    private let scale: CGFloat
    private let imageManager = PHCachingImageManager.default()
    
    init(albums: [PHAssetCollection], selectedAssetCollection: PHAssetCollection? = nil, scale: CGFloat = UIScreen.main.scale) {
        self.albums = albums
        self.selectedAssetCollection = selectedAssetCollection
        self.scale = scale
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.albums.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseId, for: indexPath) as! AlbumTableViewCell
        
        let album = self.albums[indexPath.row]
        
        cell.albumTitleLabel.attributedText = self.title(forAlbum: album)
        cell.accessoryType = self.selectedAssetCollection != nil && self.selectedAssetCollection == album ? .checkmark : .none
        
        let fetchOptions = self.assetSettings.fetchOptions.copy() as! PHFetchOptions
        fetchOptions.fetchLimit = 1
        
        let imageSize = CGSize(width: 84, height: 84).resize(by: self.scale)
        let mode: PHImageContentMode = .aspectFill
        if let asset = PHAsset.fetchAssets(in: album, options: fetchOptions).firstObject {
            self.imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: mode, options: self.assetSettings.photoOptions) { (image, _) in
                guard let image = image else {
                    return
                }
                
                cell.albumImageView.image = image
            }
        }
        
        return cell
    }
    
    private func title(forAlbum album: PHAssetCollection) -> NSAttributedString {
        return NSAttributedString(string: album.localizedTitle ?? "", attributes: self.albumTitleAttributes)
    }
    
    private lazy var albumTitleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
        NSAttributedString.Key.foregroundColor: UIColor.label
    ]
}
