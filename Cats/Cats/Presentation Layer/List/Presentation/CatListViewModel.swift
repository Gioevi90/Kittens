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
    
    @Published var isLoading: Bool
    @Published var list: [CatPresentationModel]
    
    init(store: Store<AppState>) {
        self.store = store
        
        isLoading = store.state.catListState.loading
        list = store.state.catListState.list
    }
}

extension CatListViewModel {
    func fetchList() {
        store.dispatch(fetchCats)
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
        isLoading = state.loading
        list = state.list
    }
}
