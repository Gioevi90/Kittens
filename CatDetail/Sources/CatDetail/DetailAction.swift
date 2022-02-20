//
//  DetailAction.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift
import ReSwiftThunk
import Data

public let catDetailMiddleware: Middleware<DetailState> = createThunkMiddleware()

func fetchCatDetail(identifier: String) -> Thunk<DetailState> {
    return Thunk<DetailState> { dispatch, getState in
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
