//
//  TestSubscriber.swift
//  
//
//  Created by Giovanni Catania on 21/03/22.
//

import Foundation
import ReSwift

class TestSubscriber: StoreSubscriber {
    typealias StoreSubscriberStateType = TestSubState
    
    var newStateCallCount: Int = 0
    var newStateHandler: ((TestSubState) -> Void)?
    func newState(state: TestSubState) {
        newStateCallCount += 1
        newStateHandler?(state)
    }
}
