//
//  Middleware+Pullback.swift
//  
//
//  Created by Giovanni Catania on 19/03/22.
//

import ReSwift

public func pullback<GlobalState, LocalState>(input: @escaping Middleware<LocalState>,
                                              state: KeyPath<GlobalState, LocalState>) -> Middleware<GlobalState> {
    return { globalDispatch, globalStateFunction in
        return input(globalDispatch, { globalStateFunction()?[keyPath: state] })
    }
}
