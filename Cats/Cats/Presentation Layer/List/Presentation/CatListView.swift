//
//  CatListView.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import SwiftUI
import ReSwift

struct CatListView: View {
    let viewModel: CatListViewModel
    
    init(store: Store<AppState>) {
        viewModel = CatListViewModel(store: store)
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                viewModel.subscribeToStore()
            }
            .onDisappear {
                viewModel.unsubscribeFromStore()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatListView(store: .init(reducer: appReducer, state: nil))
    }
}
