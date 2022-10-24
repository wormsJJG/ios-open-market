//
//  Page.swift
//  OpenMarket
//
//  Created by 정연호 on 2022/10/24.
//

import Foundation

struct Page: Codable {
    let id: Int
    let vendorID: Int
    let vendorName: String
    let name: String
    let pageDescription: String
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case vendorName
        case name
        case pageDescription = "description"
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
