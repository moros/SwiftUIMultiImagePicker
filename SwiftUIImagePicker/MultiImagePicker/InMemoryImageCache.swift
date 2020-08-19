//
//  InMemoryImageCache.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/19/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

class InMemoryImageCache {
    
    static let shared = InMemoryImageCache()
    private let cache: NSCache<NSString, UIImage>
    private let queue: DispatchQueue
    
    private init() {
        self.cache = NSCache<NSString, UIImage>()
        self.queue = DispatchQueue(label: "inMemoryImageCache")
    }
    
    func store(image: UIImage, forKey key: String) {
        queue.async { [weak cache] in
            cache?.setObject(image, forKey: NSString(string: key))
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        if let cached = self.cache.object(forKey: NSString(string: key)) {
            return cached
        }
        
        return nil
    }
}
