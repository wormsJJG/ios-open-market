//
//  Request.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/10/26.
//

import UIKit

enum Request {
    case productList(pageNo: Int, itemsPerPage: Int)
    case produntInfo(productId: Int)
    case thubnailImage(thumnailURL: String)
}
