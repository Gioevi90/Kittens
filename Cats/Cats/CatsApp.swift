//
//  CatsApp.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import SwiftUI
import ReSwift

var store = Store<AppState>(reducer: appReducer,
                            state: nil,
                            middleware: [catListMiddleware])

@main
struct CatsApp: App {
    var body: some Scene {
        WindowGroup {
            CatListView(store: store)
        }
    }
}
