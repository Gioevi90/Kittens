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
typealias QueryParameter = (key: String, value: Any)

enum RequestVerb {
    case get
}

struct RequestBuilder {
    let url: String
    let method: RequestVerb
    let headers: [RequestHeader]
    let queryParameters: [QueryParameter]
    
    static func get(url: String) -> RequestBuilder {
        .init(url: url,
              method: .get,
              headers: [],
              queryParameters: [])
    }
    
    private init(url: String,
                 method: RequestVerb,
                 headers: [RequestHeader],
                 queryParameters: [QueryParameter]) {
        self.url = url
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
    }
    
    func with(header: RequestHeader) -> RequestBuilder {
        .init(url: url,
              method: method,
              headers: headers + [header],
              queryParameters: queryParameters)
    }
    
    func with(headers: [RequestHeader]) -> RequestBuilder {
        .init(url: url,
              method: method,
              headers: self.headers + headers,
              queryParameters: queryParameters)
    }
    
    func with(queryParameters: [QueryParameter]) -> RequestBuilder {
        .init(url: url,
              method: method,
              headers: headers,
              queryParameters: self.queryParameters + queryParameters)
    }
    
    func build() -> Result<URLRequest, Error> {
        var request = URL
            .init(string: url.with(parameters: queryParameters))
            .map { URLRequest(url: $0) }
        headers.forEach { request?.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request.map { .success($0) } ?? .failure(APIError.invalidUrl)
    }
}

private extension String {
    func with(parameters: [QueryParameter]) -> String {
        guard parameters.count > 0 else { return self }
        return self + "?" + parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
    }
}
