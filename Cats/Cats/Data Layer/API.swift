//
//  API.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case specific(error: Error)
}

typealias RequestHeader = (key: String, value: String)

enum RequestVerb {
    case get
}

struct RequestBuilder {
    let url: String
    let method: RequestVerb
    let headers: [RequestHeader]
    
    static func get(url: String) -> RequestBuilder {
        .init(url: url,
              method: .get,
              headers: [])
    }
    
    private init(url: String,
                 method: RequestVerb,
                 headers: [RequestHeader]) {
        self.url = url
        self.method = method
        self.headers = headers
    }
    
    func with(header: RequestHeader) -> RequestBuilder {
        .init(url: url,
              method: method,
              headers: headers + [header])
    }
    
    func with(headers: [RequestHeader]) -> RequestBuilder {
        .init(url: url,
              method: method,
              headers: self.headers + headers)
    }
    
    func build() -> Result<URLRequest, Error> {
        var request = URL
            .init(string: url)
            .map { URLRequest(url: $0) }
        headers.forEach { request?.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request.map { .success($0) } ?? .failure(APIError.invalidUrl)
    }
}
