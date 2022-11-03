//
//  ImageCache.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/03.
//

import UIKit

final class ImageCache: ImageCacheable {
    private(set) var cache = NSCache<NSString, UIImage>()
    private let networkManager = NetworkManager()
    static let shared = ImageCache()
    
    func loadImage(stringUrl: String, completion: @escaping (UIImage?) -> Void){
        if let image = cache.object(forKey: stringUrl as NSString) {
            completion(image)
        }
        guard let url = URL(string: stringUrl) else { return }
        networkManager.requestData(url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                self.cache.setObject(image, forKey: stringUrl as NSString)
                completion(image)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
