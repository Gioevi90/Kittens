//
//  CatListView.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import SwiftUI
import ReSwift

let size = UIScreen.main.bounds.width / 2 - 16

struct CatListView: View {
    @ObservedObject var viewModel: CatListViewModel
    
    let columns = [ GridItem(.fixed(size)),
                    GridItem(.fixed(size))]
    
    init(store: Store<AppState>) {
        viewModel = CatListViewModel(store: store)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.list, id: \.identifier) { item in
                            NavigationLink(destination: DetailView(identifier: item.identifier,
                                                                   store: viewModel.store)) {
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
        CatListView(store: .init(reducer: appReducer, state: nil))
    }
}
