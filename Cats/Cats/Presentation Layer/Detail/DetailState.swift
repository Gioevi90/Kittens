//
//  DetailState.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

struct DetailState {
    let loading: Bool
    let model: CatDetailPresentationModel?
    let error: Error?
}
