//
//  LoadCategories.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Lists the category names shown on the home page, unique and in alphabetical order.
struct LoadCategories: Sendable {
    let repository: any ProductRepository

    func execute() async throws -> [String] {
        let products = try await repository.products()
        return Set(products.map(\.category)).sorted()
    }
}
