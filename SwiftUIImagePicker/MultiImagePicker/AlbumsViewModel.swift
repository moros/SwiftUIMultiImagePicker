//
//  AlbumsViewModel.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//

import Combine
import Foundation
import Photos
import UIKit

internal class AlbumsViewModel {
    
    /// Various settings for fetching albums.
    ///
    var albumSettings: AlbumSettings = AlbumSettings.shared
    
    /// Various settings for fetching assets.
    ///
    var assetSettings: AssetSettings = AssetSettings.shared
    
    /// Controller provided to model to allow nav bar title button to present album controller.
    ///
    var navigationController: UINavigationController? = nil
    
    /// Delegate informing listener of album (asset collection) that was selected by the user.
    ///
    weak var delegate: AlbumsViewControllerDelegate?
    
    /// Album that was selected.
    ///
    var selectedAssetCollection: PHAssetCollection? = nil
    
    /// Transitioning delegate used to present album controller as a popover iPad style view.
    ///
//    private var transitionDelegate: PopoverTransitionDelegate? = nil
    
    @objc func albumsButtonPressed(_ sender: UIButton) {

        let controller = AlbumsViewController()
        controller.albums = self.albums
        controller.selectedAssetCollection = self.selectedAssetCollection
        controller.delegate = self.delegate
        controller.onDismiss = {
            controller.popover.enablePopover = false
            self.rotateButtonArrow(sender)
        }
        
        let window: UIWindow? = UIApplication.shared.windows.first
        controller.popover.enablePopover = true
        controller.popover.popoverPresentationController?.sourceView = sender
        controller.popover.popoverPresentationController?.sourceRect = sender.convert(sender.bounds, to: window)

        let frame = window?.frame ?? CGRect.zero
        let height = frame.height * (self.isLandscape ? 0.75 : 0.5)
        controller.preferredContentSize = CGSize(width: frame.width * 0.75, height: height)
        rotateButtonArrow(sender)
        
        self.navigationController?.viewControllers.first?.present(controller, animated: true, completion: nil)
    }
    
    private lazy var albums: [PHAssetCollection] = {
        
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
    
    private var isLandscape: Bool {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
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
