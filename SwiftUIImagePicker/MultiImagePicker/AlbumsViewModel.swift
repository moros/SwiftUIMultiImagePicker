//
//  AlbumsViewModel.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Combine
import Foundation
import Photos
import UIKit

public class AlbumsViewModel: ObservableObject {
    
    var albumSettings: AlbumSettings = AlbumSettings.shared
    var assetSettings: AssetSettings = AssetSettings.shared
    var navigationController: UINavigationController? = nil
    private var transitionDelegate: DropdownTransitionDelegate? = nil
    
    public let objectWillChange = PassthroughSubject<PHAssetCollection, Never>()
    var selectedAssetCollection: PHAssetCollection? = nil {
        didSet {
            if selectedAssetCollection != nil {
                objectWillChange.send(selectedAssetCollection!)
            }
        }
    }
    
    var isLandscape: Bool {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    }
    
    @objc func albumsButtonPressed(_ sender: UIButton) {

        let controller = AlbumsViewController()
        controller.albums = self.albums
        controller.selectedAssetCollection = self.selectedAssetCollection
        controller.delegate = self
        controller.onDismiss = {
            self.rotateButtonArrow(sender)
        }
        
        let delegate = DropdownTransitionDelegate()
        
        let window: UIWindow? = UIApplication.shared.windows.first
        delegate.sourceView = sender
        delegate.sourceRect = sender.convert(sender.bounds, to: window)
        self.transitionDelegate = delegate
        
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self.transitionDelegate
        
        let frame = window?.frame ?? CGRect.zero
        let height = frame.height * (self.isLandscape ? 0.75 : 0.5)
        controller.preferredContentSize = CGSize(width: frame.width * 0.75, height: height)
        rotateButtonArrow(sender)
        
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    lazy var albums: [PHAssetCollection] = {
        
        // We don't want collections without assets.
        // I would like to do that with PHFetchOptions: fetchOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        // But that doesn't work... This seems suuuuuper ineffective...
        let fetchOptions = self.assetSettings.fetchOptions.copy() as! PHFetchOptions
        fetchOptions.fetchLimit = 1
        
        var items: [PHAssetCollection] = []
        items.append(contentsOf: self.filterCollection(self.albumSettings.fetchFavorites, fetchOptions: fetchOptions))
        items.append(contentsOf: self.filterCollection(self.albumSettings.fetchAlbums, fetchOptions: fetchOptions))
        
        return items
    }()
    
    private func filterCollection(_ collection: [PHFetchResult<PHAssetCollection>], fetchOptions: PHFetchOptions) -> [PHAssetCollection] {
        return collection.filter {
            $0.count > 0
        }.flatMap {
            $0.objects(at: IndexSet(integersIn: 0..<$0.count))
        }.filter {
            // We can't use estimatedAssetCount on the collection
            // It returns NSNotFound. So actually fetch the assets...
            let assetsFetchResult = PHAsset.fetchAssets(in: $0, options: fetchOptions)
            return assetsFetchResult.count > 0
        }
    }
    
    private func rotateButtonArrow(_ button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            guard let imageView = button.imageView else {
                return
            }
            
            imageView.transform = imageView.transform.rotated(by: .pi)
        }
    }
}

extension AlbumsViewModel: AlbumsViewControllerDelegate {
    
    func albumsViewController(_ viewController: AlbumsViewController, didSelectAlbum ablum: PHAssetCollection) {
        self.selectedAssetCollection = ablum
    }
}
