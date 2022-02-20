//
//  DetailState.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

public struct DetailState {
    let loading: Bool
    let model: CatDetailPresentationModel?
    let error: Error?
}

public extension DetailState {
    static var defaultValue: DetailState {
        .init(loading: false,
              model: nil,
              error: nil)
    }
}
