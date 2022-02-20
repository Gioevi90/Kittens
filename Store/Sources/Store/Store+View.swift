//
//  Store+View.swift
//  
//
//  Created by Giovanni Catania on 19/03/22.
//

import ReSwift

public extension Store {
    func view<LocalState, S: StoreSubscriber>(state: KeyPath<State, LocalState>) -> LocalStore<LocalState, S> where S.StoreSubscriberStateType == LocalState {
        LocalStore<LocalState, S>(getState: { self.state[keyPath: state] },
                                  dispatchFunction: { self.dispatch($0) },
                                  subscribeFunction: { self.subscribe($0) { $0.select { $0[keyPath: state]  }} },
                                  unsubscribeFunction: { self.unsubscribe($0) })
    }
}
