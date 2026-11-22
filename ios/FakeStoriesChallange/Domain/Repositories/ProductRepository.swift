//
//  ProductRepository.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Source of catalogue data; the app depends on this, not on any API.
protocol ProductRepository: Sendable {
    func products() async throws -> [Product]
    func product(id: Int) async throws -> Product
}
