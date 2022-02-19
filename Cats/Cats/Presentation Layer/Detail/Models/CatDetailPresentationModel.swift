//
//  CatDetailPresentationModel.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import Data

struct CatDetailPresentationModel {
    let identifier: String
    let imageUrl: String
    let categories: [CatDetailCategory]
    let breeds: [CatDetailBreed]
}

struct CatDetailCategory {
    let name: String
}

struct CatDetailBreed {
    let name: String
}

extension CatDetailPresentationModel {
    init(_ dto: CatDetailDto) {
        self.identifier = dto.id ?? ""
        self.imageUrl = dto.url ?? ""
        self.categories = dto.categories?.compactMap(CatDetailCategory.init) ?? []
        self.breeds = dto.breeds?.compactMap(CatDetailBreed.init) ?? []
    }
}

extension CatDetailCategory {
    init?(_ dto: CategoryDto) {
        guard let name = dto.name else { return nil }
        self.name = name
    }
}

extension CatDetailBreed {
    init?(_ dto: BreedDto) {
        guard let name = dto.name else { return nil }
        self.name = name
    }
}
