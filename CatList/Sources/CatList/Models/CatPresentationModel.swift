//
//  CatListPresentationModel.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import Data

struct CatPresentationModel {
    let identifier: String
    let imageUrl: String
}

extension CatPresentationModel {
    init?(_ dto: CatDto) {
        guard let id = dto.id else { return nil }
        self.identifier = id
        self.imageUrl = dto.url ?? ""
    }
}
