//
//  CatListView.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import SwiftUI
import ReSwift
import CatDetail
import Store

let size = UIScreen.main.bounds.width / 2 - 16

public struct CatListView: View {
    @ObservedObject var viewModel: CatListViewModel
    
    let columns = [ GridItem(.fixed(size)),
                    GridItem(.fixed(size))]
    
    public init(store: LocalStore<CatListState, CatListViewModel>,
                detailStore: @escaping (LocalStore<CatListState, CatListViewModel>) -> LocalStore<DetailState, CatDetailViewModel>) {
        viewModel = CatListViewModel(store: store,
                                     detailStore: detailStore)
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.list, id: \.identifier) { item in
                            NavigationLink(destination: DetailView(identifier: item.identifier,
                                                                   store: viewModel.detailStore(viewModel.store))) {
                                CatCell(url: item.imageUrl, size: size)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding(.horizontal, 8)
            .navigationTitle("Cats")
        }
        .onAppear {
            viewModel.subscribeToStore()
            viewModel.fetchList()
        }
        .onDisappear {
            viewModel.unsubscribeFromStore()
        }
    }
}

struct CatCell: View {
    let url: String
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size, alignment: .center)
                .clipped()
        } placeholder: {
            ProgressView()
        }
        .frame(width: size, height: size)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let catListStore = Store<CatListState>.init(reducer: catListReducer, state: nil)
        let catDetailStore = Store<DetailState>.init(reducer: catDetailReducer, state: nil)
        CatListView(store: .init(getState: { catListStore.state },
                                 dispatchFunction: { catListStore.dispatch($0) },
                                 subscribeFunction: { catListStore.subscribe($0) },
                                 unsubscribeFunction: { catListStore.unsubscribe($0) }),
                    detailStore: { _ in .init(getState: { catDetailStore.state },
                                              dispatchFunction: { catDetailStore.dispatch($0) },
                                              subscribeFunction: { catDetailStore.subscribe($0) },
                                              unsubscribeFunction: { catDetailStore.unsubscribe($0) }) })
    }
}
