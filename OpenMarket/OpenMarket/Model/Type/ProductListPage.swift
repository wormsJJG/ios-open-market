//
//  ProductList.swift
//  OpenMarket
//
//  Created by 정연호 on 2022/10/24.
//

import Foundation

struct ProductListPage: Decodable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Page]
    
    enum CodingKeys: String, CodingKey {
        case pageNo
        case itemsPerPage
        case totalCount
        case offset
        case limit
        case lastPage
        case hasNext
        case hasPrev
        case pages
    }
}
