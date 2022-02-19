//
//  AppReducer.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(catListState: catListReducer(action: action, state: state?.catListState))
}
