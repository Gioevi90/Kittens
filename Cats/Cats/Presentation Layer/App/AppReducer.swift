//
//  AppReducer.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import ReSwift
import CatDetail
import CatList

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(catListState: catListReducer(action: action, state: state?.catListState),
                    catDetailState: catDetailReducer(action: action, state: state?.catDetailState))
}
