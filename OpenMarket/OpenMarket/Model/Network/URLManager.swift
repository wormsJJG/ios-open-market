//
//  URL.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/11/04.
//

import UIKit

struct URLManager {
    let scheme = "https"
    let host = "openmarket.yagom-academy.kr"
    let path = "/api/products"
    var baseComponent: URLComponents
    
    init() {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        self.baseComponent = urlComponents
    }
    
    mutating func requestURL(requestType: Request) -> URLComponents? {
        switch requestType {
        case .productList(pageNo: let pageNo, itemsPerPage: let itemsPerPage):
            var component = self.baseComponent
            component.path = self.path
            component.queryItems = [URLQueryItem(name: "page_no", value: "\(pageNo)"),
                                    URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")]
            
            return component
        case .produntInfo(productId: let productId):
            var component = self.baseComponent
            component.path = self.path + "/\(productId)"
            
            return component
        case .thubnailImage(thumnailURL: let thumbnailURL):
            guard let component = URLComponents(string: thumbnailURL) else {
                return nil
            }
            
            return component
        }
    }
}
