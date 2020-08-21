//
//  AssetSettings.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/21/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import Photos

public class AssetSettings: NSObject {
    
    public static let shared = AssetSettings()
    internal override init() {
    }
    
    public enum MediaTypes {
        case image
        case video

        fileprivate var assetMediaType: PHAssetMediaType {
            switch self {
            case .image:
                return .image
            case .video:
                return .video
            }
        }
    }
    
    public lazy var supportedMediaTypes: Set<MediaTypes> = [.image]
    
    public lazy var fetchOptions: PHFetchOptions = {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        let rawMediaTypes = supportedMediaTypes.map { $0.assetMediaType.rawValue }
        let predicate = NSPredicate(format: "mediaType IN %@", rawMediaTypes)
        fetchOptions.predicate = predicate

        return fetchOptions
    }()
    
    public lazy var photoOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true

        return options
    }()
}
