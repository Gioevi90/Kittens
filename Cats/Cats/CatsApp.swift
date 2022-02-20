//
//  CatsApp.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import SwiftUI
import ReSwift
import CatList
import CatDetail
import Store

var store = Store<AppState>(reducer: appReducer,
                            state: nil,
                            middleware: [pullback(input: catListMiddleware, state: \.catListState),
                                         pullback(input: catDetailMiddleware, state: \.catDetailState)])

@main
struct CatsApp: App {
    var body: some Scene {
        WindowGroup {
            CatListView(store: store.view(state: \.catListState),
                        detailStore: { _ in store.view(state: \.catDetailState) })
        }
    }
}
