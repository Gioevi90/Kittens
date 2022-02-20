//
//  DetailView.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import SwiftUI
import ReSwift
import Store

public struct DetailView: View {
    @ObservedObject var viewModel: CatDetailViewModel
    
    public init(identifier: String, store: LocalStore<DetailState, CatDetailViewModel>) {
        viewModel = .init(identifier: identifier,
                          store: store)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: viewModel.model.flatMap { URL(string: $0.imageUrl) }) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            Text(viewModel.categories)
            Text(viewModel.breeds)
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.subscribeToStore()
            viewModel.fetchDetail()
        }
        .onDisappear {
            viewModel.unsubscribeFromStore()
        }
        .alert(Text(viewModel.error?.localizedDescription ?? ""),
                isPresented: $viewModel.isError,
               actions: { Button("OK") {}
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store<DetailState>(reducer: catDetailReducer, state: nil)
        DetailView(identifier: "id", store: .init(getState: { store.state },
                                                  dispatchFunction: { store.dispatch($0) },
                                                  subscribeFunction: { store.subscribe($0) },
                                                  unsubscribeFunction: { store.unsubscribe($0) }))
    }
}
