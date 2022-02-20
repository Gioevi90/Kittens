//
//  DetailViewModel.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation
import ReSwift
import Store

public class CatDetailViewModel: ObservableObject {
    let store: LocalStore<DetailState, CatDetailViewModel>
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
    
    init(identifier: String, store: LocalStore<DetailState, CatDetailViewModel>) {
        self.store = store
        self.identifier = identifier
        
        isLoading = store.state.loading
        model = store.state.model
        error = store.state.error
        isError = store.state.error != nil
    }
}

extension CatDetailViewModel {
    func fetchDetail() {
        store.dispatch(fetchCatDetail(identifier: identifier))
    }
}

extension CatDetailViewModel: StoreSubscriber {
    public typealias StoreSubscriberStateType = DetailState
    
    func subscribeToStore() {
        store
            .subscribe(self) { $0.select { $0 } }
    }
    
    func unsubscribeFromStore() {
        store
            .unsubscribe(self)
    }
    
    public func newState(state: DetailState) {
        isLoading = state.loading
        model = state.model
        error = state.error
        isError = state.error != nil
    }
}
