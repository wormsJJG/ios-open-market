//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/10/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case HTTPStatusCodeError
    case ImportDataFailed
    case UnownURL
    
    var errorDescription: String {
        switch self {
        case .HTTPStatusCodeError:
            return "HTTP 상태 코드 에러"
        case .ImportDataFailed:
            return "데이터 불러오기 실패"
        case .UnownURL:
            return "알수없는 URL"
        }
    }
}
