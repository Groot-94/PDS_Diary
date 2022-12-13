//
//  WiseSayingRequest.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/06.
//

struct WiseSayingRequest: APIRequest {
    var baseURL: String = "https://api.qwer.pw/request/helpful_text"
    var path: String?
    var method: HTTPMethod = .get
    var headers: [String : String]?
    var query: [String : String]? = ["apikey": "guest"]
    var body: String?
}
