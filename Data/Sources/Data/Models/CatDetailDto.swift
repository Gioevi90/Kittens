//
//  CatDetailDto.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

public struct CatDetailDto: Codable {
    public let id: String?
    public let url: String?
    public let sub_id: String?
    public let created_at: String?
    public let original_filename: String?
    public let categories: [CategoryDto]?
    public let breeds: [BreedDto]?
}

public struct CategoryDto: Codable {
    public let id: Int?
    public let name: String?
}

public struct BreedDto: Codable {
    public let id: String?
    public let name: String?
    public let temperament: String?
    public let life_span: String?
    public let alt_names: String?
    public let wikipedia_url: String?
    public let origin: String?
    public let weight_imperial: String?
}
