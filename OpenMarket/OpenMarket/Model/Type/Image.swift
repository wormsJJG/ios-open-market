//
//  Image.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/10/25.
//

import Foundation

struct Image: Decodable {
    let id: Int
    let url, thumbnailURL: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
