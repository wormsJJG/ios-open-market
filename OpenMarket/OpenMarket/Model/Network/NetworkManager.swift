//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/10/26.
//

import Foundation

class NetworkManager {
    let urlSession: URLSession
    
    init() {
        self.urlSession = URLSession.shared
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping(Result<Data, NetworkError>) -> Void ) {
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            guard let httpResponse = urlResponse as? HTTPURLResponse, (HTTPStatus.ok.range).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.HTTPStatusCodeError))
            }
            guard let data = data else {
                return completionHandler(.failure(.ImportDataFailed))
            }
            completionHandler(.success(data))
        }
        task.resume()
    }
    
    func getData(requestType: Request, completionHandler: @escaping(Result<Data, NetworkError>) -> Void ) {
        guard let url = URL(string: requestType.url) else {
            return completionHandler(.failure(NetworkError.UnownURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}
