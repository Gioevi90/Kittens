//
//  File.swift
//  
//
//  Created by Giovanni Catania on 21/03/22.
//

import Foundation
import ReSwift

func testReducer(action: Action, state: TestState?) -> TestState {
    return TestState(subState: subTestReducer(action: action, state: state?.subState))
}

func subTestReducer(action: Action, state: TestSubState?) -> TestSubState {
    let state = state ?? .init(value: "value")
    switch action {
    case let event as TestAction.ChangeValueAction:
        return TestSubState(value: event.value)
    default:
        break
    }
    return state
}

