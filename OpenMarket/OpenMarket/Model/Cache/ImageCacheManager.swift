//
//  ImageCache.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/03.
//

import UIKit

final class ImageCacheManager: ImageCacheable {
    static var cache = NSCache<NSString, UIImage>()
    
    static func loadImage(stringUrl: String, completion: @escaping (UIImage?) -> Void) {
        if let image = ImageCacheManager.cache.object(forKey: stringUrl as NSString) {
            completion(image)
        }
        
        NetworkManager.getData(requestType: .thubnailImage(thumnailURL: stringUrl)) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                ImageCacheManager.cache.setObject(image, forKey: stringUrl as NSString)
                completion(image)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
