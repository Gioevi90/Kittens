//
//  CatListViewModel.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift

class CatListViewModel: ObservableObject {
    let store: Store<AppState>
    
    init(store: Store<AppState>) {
        self.store = store
    }
}

extension CatListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = CatListState
    
    func subscribeToStore() {
        store
            .subscribe(self) { $0.select { $0.catListState } }
    }
    
    func unsubscribeFromStore() {
        store
            .unsubscribe(self)
    }
    
    func newState(state: CatListState) {
        // do something with the new state
    }
}
