//
//  ImageCache.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-11.
//

import UIKit

final class ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    func image(forKey key: URL) -> UIImage? {
        cache.object(forKey: key as NSURL)
    }

    func setImage(_ image: UIImage, forKey key: URL) {
        cache.setObject(image, forKey: key as NSURL)
    }
}
