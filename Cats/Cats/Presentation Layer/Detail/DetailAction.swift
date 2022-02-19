//
//  DetailAction.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift
import ReSwiftThunk

func fetchCatDetail(identifier: String) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        dispatch(CatDetailAction.Fetch())
        Task { @MainActor in
            let detail = await fetchCatDetail(identifier: identifier)
                .map(CatDetailPresentationModel.init)
            switch detail {
            case let .success(detail):
                dispatch(CatDetailAction.SetDetail(model: detail))
            case let .failure(error):
                dispatch(CatDetailAction.SetError(error: error))
            }
        }
    }
}


struct CatDetailAction: Action {}

extension CatDetailAction {
    struct Fetch: Action {}
}

extension CatDetailAction {
    struct SetDetail: Action {
        let model: CatDetailPresentationModel
    }
}

extension CatDetailAction {
    struct SetError: Action {
        let error: Error
    }
}
