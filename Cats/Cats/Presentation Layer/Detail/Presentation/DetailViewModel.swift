//
//  DetailViewModel.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift

class CatDetailViewModel: ObservableObject {
    let store: Store<AppState>
    let identifier: String
    
    @Published var model: CatDetailPresentationModel?
    @Published var isLoading: Bool
    @Published var error: Error?
    @Published var isError: Bool
    
    var categories: String {
        model.map { "Categories: \($0.categories.map { $0.name }.joined(separator: ", "))" } ?? ""
    }
    var breeds: String {
        model.map { "Breeds: \($0.breeds.map { $0.name }.joined(separator: ", "))" } ?? ""
    }
    
    init(identifier: String, store: Store<AppState>) {
        self.store = store
        self.identifier = identifier
        
        isLoading = store.state.catDetailState.loading
        model = store.state.catDetailState.model
        error = store.state.catDetailState.error
        isError = store.state.catDetailState.error != nil
    }
}

extension CatDetailViewModel {
    func fetchDetail() {
        store.dispatch(fetchCatDetail(identifier: identifier))
    }
}

extension CatDetailViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = DetailState
    
    func subscribeToStore() {
        store
            .subscribe(self) { $0.select { $0.catDetailState } }
    }
    
    func unsubscribeFromStore() {
        store
            .unsubscribe(self)
    }
    
    func newState(state: DetailState) {
        isLoading = state.loading
        model = state.model
        error = state.error
        isError = state.error != nil
    }
}
