//
//  CatDetailDto.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

struct CatDetailDto: Codable {
    let id: String?
    let url: String?
    let sub_id: String?
    let created_at: String?
    let original_filename: String?
    let categories: [CategoryDto]?
    let breeds: [BreedDto]?
}

struct CategoryDto: Codable {
    let id: Int?
    let name: String?
}

struct BreedDto: Codable {
    let id: String?
    let name: String?
    let temperament: String?
    let life_span: String?
    let alt_names: String?
    let wikipedia_url: String?
    let origin: String?
    let weight_imperial: String?
}
