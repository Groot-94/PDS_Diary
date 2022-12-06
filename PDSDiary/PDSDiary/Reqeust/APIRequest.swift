//
//  APIRequest.swift
//  MyMarvelComics
//
//  Created by Groot on 2022/10/31.
//

import Foundation

protocol APIRequest {
    var baseURL: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: String? { get }
}

extension APIRequest {
    var url: URL? {
        var component = URLComponents(string: self.baseURL + (self.path ?? ""))
        component?.queryItems = query?.reduce([URLQueryItem]()) {
            $0 + [URLQueryItem(name: $1.key, value: $1.value)]
        }
        
        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body?.data(using: .utf8)
        
        self.headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    }
}

extension APIRequest {
    func excute(completionHandler: @escaping (Result<[[String : Any]], Error>) -> Void) {
        guard let url = self.url else { return completionHandler(.failure(APIError.noneUrlValue)) }
        
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else { return completionHandler(.failure(APIError.request)) }
            
            guard let response = response as? HTTPURLResponse,
                  200 <= response.statusCode, response.statusCode < 300
            else {
                return completionHandler(.failure(APIError.response))
            }
            
            guard let data = data else { return completionHandler(.failure(APIError.invalidData)) }
            
            
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]]
            else { return completionHandler(.failure(APIError.decode)) }
            
            completionHandler(.success(jsonData))
        }
        
        task.resume()
    }
}
