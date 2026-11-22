//
//  LoadState.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// What a screen shows while its data loads; every screen uses the same outcomes.
enum LoadState<Value: Equatable & Sendable>: Equatable, Sendable {
    case idle
    case loading
    case loaded(Value)
    case failed(CatalogueError)

    var value: Value? {
        if case .loaded(let value) = self { return value }
        return nil
    }
}
