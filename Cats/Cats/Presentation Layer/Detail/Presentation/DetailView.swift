//
//  DetailView.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import SwiftUI
import ReSwift

struct DetailView: View {
    @ObservedObject var viewModel: CatDetailViewModel
    
    init(identifier: String, store: Store<AppState>) {
        viewModel = .init(identifier: identifier,
                          store: store)
    }
    
    var body: some View {
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
        DetailView(identifier: "id", store: .init(reducer: appReducer, state: nil))
    }
}
