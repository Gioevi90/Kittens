//
//  CatListRequest.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

func fetchCatList(limit: Int = 100) async -> Result<[CatDto], Error> {
    await CatListRequest
        .create()
        .with(limit: limit)
        .build()
        .flatMap { data in await result { try await URLSession.shared.data(for: data, delegate: nil) } }
        .flatMap { data in result { try JSONDecoder().decode([CatDto].self, from: data.0) } }
}

struct CatListRequest {
    let limit: Int
    
    private init(limit: Int) {
        self.limit = limit
    }
    
    static func create() -> CatListRequest {
        .init(limit: 1)
    }
    
    func with(limit: Int) -> CatListRequest {
        .init(limit: limit)
    }
    
    func build() -> Result<URLRequest, Error> {
        RequestBuilder
            .get(url: "https://api.thecatapi.com/v1/images/search")
            .with(queryParameters: [(key: "limit", value: limit)])
            .with(header: (key: "x-api-key", value: ""))
            .build()
    }
}
