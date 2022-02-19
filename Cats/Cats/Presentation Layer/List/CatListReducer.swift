//
//  CatListReducer.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift

func catListReducer(action: Action, state: CatListState?) -> CatListState {
    var state = state ?? .init(list: [], error: nil, loading: false)
    
    switch action {
    case _ as CatListAction.Fetch:        
        state = .init(list: [], error: nil, loading: true)
    case let event as CatListAction.SetError:
        state = .init(list: [], error: event.error, loading: false)
    case let event as CatListAction.SetList:
        state = .init(list: event.list, error: nil, loading: false)
    default:
        break
    }
    
    return state
}
