//
//  CatListState.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift

struct CatListState {
    var list: [CatPresentationModel]
    var error: Error?
    var loading: Bool
}
