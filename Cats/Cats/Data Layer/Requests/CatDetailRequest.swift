//
//  CatDetailRequest.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

func fetchCatDetail(identifier: String) async -> Result<CatDetailDto, Error> {
    await CatDetailRequest
        .create(identifier: identifier)
        .build()
        .flatMap { data in await result { try await URLSession.shared.data(for: data, delegate: nil) } }
        .flatMap { data in result { try JSONDecoder().decode(CatDetailDto.self, from: data.0) } }
}

struct CatDetailRequest {
    let identifier: String
    
    private init(identifier: String) {
        self.identifier = identifier
    }
    
    static func create(identifier: String) -> CatDetailRequest {
        .init(identifier: identifier)
    }
    
    func build() -> Result<URLRequest, Error> {
        RequestBuilder
            .get(url: "https://api.thecatapi.com/v1/images/\(identifier)")
            .with(header: (key: "x-api-key", value: ""))
            .build()
    }
}
