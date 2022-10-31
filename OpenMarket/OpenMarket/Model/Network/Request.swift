//
//  Request.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/10/26.
//

import Foundation

enum Request {
    static let apiHost = "https://openmarket.yagom-academy.kr"
    
    case productList(pageNo: Int, itemsPerPage: Int)
    case produntInfo(productId: Int)
    
    var url: String {
        switch self {
        case .productList(pageNo: let pageNo, itemsPerPage: let itemsPerPage):
            return "\(Request.apiHost)/api/products?page_no=\(pageNo)&items_per_page=\(itemsPerPage)"
        case .produntInfo(productId: let productId):
            return "\(Request.apiHost)/api/products/\(productId)"
        }
    }
}
