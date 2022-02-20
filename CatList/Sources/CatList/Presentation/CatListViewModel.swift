//
//  CatListViewModel.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift
import Store
import CatDetail

public class CatListViewModel: ObservableObject {
    let store: LocalStore<CatListState, CatListViewModel>
    let detailStore: (LocalStore<CatListState, CatListViewModel>) -> LocalStore<DetailState, CatDetailViewModel>
    
    @Published var isLoading: Bool
    @Published var list: [CatPresentationModel]
    
    init(store: LocalStore<CatListState, CatListViewModel>,
         detailStore: @escaping (LocalStore<CatListState, CatListViewModel>) -> LocalStore<DetailState, CatDetailViewModel>) {
        self.store = store
        self.detailStore = detailStore
        
        isLoading = store.state.loading
        list = store.state.list
    }
}

extension CatListViewModel {
    func fetchList() {
        store.dispatch(fetchCats)
    }
}

extension CatListViewModel: StoreSubscriber {
    public typealias StoreSubscriberStateType = CatListState
    
    func subscribeToStore() {
        store
            .subscribe(self) { $0.select { $0 } }
    }
    
    func unsubscribeFromStore() {
        store
            .unsubscribe(self)
    }
    
    public func newState(state: CatListState) {
        isLoading = state.loading
        list = state.list
    }
}
