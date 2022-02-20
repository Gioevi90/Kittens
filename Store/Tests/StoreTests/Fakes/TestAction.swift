//
//  File.swift
//  
//
//  Created by Giovanni Catania on 21/03/22.
//

import Foundation
import ReSwift

struct TestAction: Action {
    struct ChangeValueAction: Action {
        let value: String
    }
}
