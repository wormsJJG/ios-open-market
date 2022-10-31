//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/10/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case statusCodeError
    case importDataFailed
    case invalidURL
    
    var errorDescription: String {
        switch self {
        case .statusCodeError:
            return "HTTP 상태 코드 에러"
        case .importDataFailed:
            return "데이터 불러오기 실패"
        case .invalidURL:
            return "알수없는 URL"
        }
    }
}
