//
//  Result+Extensions.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import Foundation

func result<U>(_ fun: () async throws -> U) async -> Result<U, Error> {
    do {
        let result = try await fun()
        return .success(result)
    } catch {
        return .failure(error)
    }
}

func result<U>(_ fun: () throws -> U) -> Result<U, Error> {
    do {
        let result = try fun()
        return .success(result)
    } catch {
        return .failure(error)
    }
}

extension Result {
    @inlinable public func flatMap<NewSuccess>(_ transform: (Success) async -> Result<NewSuccess, Failure>) async -> Result<NewSuccess, Failure> {
        switch self {
        case let .success(value):
            async let transformed = transform(value)
            return await transformed
        case let .failure(error):
            return .failure(error)
        }
    }
}
