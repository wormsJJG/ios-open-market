//
//  ProductList.swift
//  OpenMarket
//
//  Created by 정연호 on 2022/10/24.
//

import Foundation

struct ProductListPage: Codable {
    var pageNo: Int
    var itemsPerPage: Int
    var totalCount: Int
    var offset: Int
    var limit: Int
    var lastPage: Int
    var hasNext: Bool
    var hasPrev: Bool
    var productList: [Product]
    
    enum CodingKeys: String, CodingKey {
        case pageNo
        case itemsPerPage
        case totalCount
        case offset
        case limit
        case lastPage
        case hasNext
        case hasPrev
        case productList = "pages"
    }
}
