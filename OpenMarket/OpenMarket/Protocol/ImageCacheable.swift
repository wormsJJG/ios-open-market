//
//  File.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/03.
//

import UIKit

protocol ImageCacheable {
    static func loadImage(stringUrl: String, completion: @escaping (UIImage?) -> Void)
}
