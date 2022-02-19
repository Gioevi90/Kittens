//
//  DetailReducer.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift

func catDetailReducer(action: Action, state: DetailState?) -> DetailState {
    var state = state ?? .init(loading: false, model: nil, error: nil)
    
    switch action {
    case _ as CatDetailAction.Fetch:
        state = .init(loading: true, model: nil, error: nil)
    case let event as CatDetailAction.SetError:
        state = .init(loading: false, model: nil, error: event.error)
    case let event as CatDetailAction.SetDetail:
        state = .init(loading: false, model: event.model, error: nil)
    default:
        break
    }
    
    return state
}

