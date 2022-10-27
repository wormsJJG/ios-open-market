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
    
    func dataTask(request: URLRequest, completion: @escaping(Result<Data, NetworkError>) -> Void ) {
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            guard let httpResponse = urlResponse as? HTTPURLResponse, (HTTPStatus.ok.range).contains(httpResponse.statusCode) else {
                return completion(.failure(.HTTPStatusCodeError))
            }
            guard let data = data else {
                return completion(.failure(.ImportDataFailed))
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    func getData(requestType: Request, completion: @escaping(Result<Data, NetworkError>) -> Void ) {
        guard let url = URL(string: requestType.url) else {
            return completion(.failure(NetworkError.UnownURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        
        dataTask(request: request, completion: completion)
    }
}
