//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 정재근 on 2022/10/26.
//

import Foundation

final class NetworkManager {
    let urlSession: URLSession
    private var urlManager: URLManager
    
    init() {
        self.urlSession = URLSession.shared
        self.urlManager = URLManager()
    }
    
    func dataTask(request: URLRequest, completion: @escaping(Result<Data, NetworkError>) -> Void ) {
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            
            guard let httpResponse = urlResponse as? HTTPURLResponse, (HTTPStatus.ok.range).contains(httpResponse.statusCode) else {
                return completion(.failure(.statusCodeError))
            }
            guard let data = data else {
                return completion(.failure(.importDataFailed))
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func getData(requestType: Request, completion: @escaping(Result<Data, NetworkError>) -> Void ) {
        guard let url = urlManager.requestURL(requestType: requestType)?.url else {
            return completion(.failure(NetworkError.invalidURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        
        dataTask(request: request, completion: completion)
    }
    
    func requestData(_ url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        
        dataTask(request: request, completion: completion)
    }
}
