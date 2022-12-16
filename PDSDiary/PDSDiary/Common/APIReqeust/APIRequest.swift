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
        component?.queryItems = query?.reduce([URLQueryItem]()) { $0 + [URLQueryItem(name: $1.key, value: $1.value)] }
        
        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body?.data(using: .utf8)
        self.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}

extension APIRequest {
    func excute() async -> (Result<[[String : Any]], Error>) {
        guard let url = self.url else { return .failure(APIError.noneUrlValue) }
        
        do {
            let (data, response) = try await URLSession(configuration: .default).data(from: url)
            guard let response = response as? HTTPURLResponse, 200 <= response.statusCode, response.statusCode < 300
            else { return .failure(APIError.response) }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]]
            else { return .failure(APIError.decode) }
            
            return .success(jsonData)
        } catch {
            return .failure(APIError.request)
        }
    }
}
