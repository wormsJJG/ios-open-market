//
//  HTTPStatus.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/10/26.
//

import Foundation

enum HTTPMethod {
    static let get: String = "GET"
    static let post: String = "POST"
    static let patch: String = "PATCH"
    static let delete: String = "DELETE"
}

enum HTTPStatus {
    case continueStatus
    case ok
    case badRequest
    case internalServerError
    case error
    
    var range: Range<Int> {
        switch self {
        case .continueStatus:
            return 100..<200
        case .ok:
            return 200..<300
        case .badRequest:
            return 300..<400
        case .internalServerError:
            return 400..<500
        case .error:
            return 500..<600
        }
    }
}
