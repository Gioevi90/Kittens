//
//  CatListRequest.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

func fetchCatList() async -> Result<[CatDto], Error> {
    await CatListRequest
        .build()
        .flatMap { data in await result { try await URLSession.shared.data(for: data, delegate: nil) } }
        .flatMap { data in result { try JSONDecoder().decode([CatDto].self, from: data.0) } }
}

struct CatListRequest {
    static func build() -> Result<URLRequest, Error> {
        RequestBuilder
            .get(url: "https://api.thecatapi.com/v1/images/search?limit=100")
            .with(header: (key: "x-api-key", value: ""))
            .build()
    }
}
