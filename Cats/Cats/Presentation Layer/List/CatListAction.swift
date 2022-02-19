//
//  CatListAction.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import ReSwift
import ReSwiftThunk

let catListMiddleware: Middleware<AppState> = createThunkMiddleware()

let fetchCats = Thunk<AppState> { dispatch, getState in
    dispatch(CatListAction.Fetch())
    Task { @MainActor in
        let list = await fetchCatList()
            .map { $0.compactMap(CatPresentationModel.init) }
        
        switch list {
        case let .success(list):
            dispatch(CatListAction.SetList(list: list))
        case let .failure(error):
            dispatch(CatListAction.SetError(error: error))
        }
    }
}

struct CatListAction: Action {}

extension CatListAction {
    struct Fetch: Action {}
}

extension CatListAction {
    struct SetError: Action {
        let error: Error
    }
}

extension CatListAction {
    struct SetList: Action {
        let list: [CatPresentationModel]
    }
}
