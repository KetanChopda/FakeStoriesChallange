//
//  SearchProducts.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Returns products matching a query; a blank term matches nothing, and a category limits the search to it.
struct SearchProducts: Sendable {
    let repository: any ProductRepository

    func execute(_ query: ProductQuery) async throws -> [Product] {
        let term = query.term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return [] }
        let products = try await repository.products()
        let scoped = query.categoryName.map { name in products.filter { $0.category == name } } ?? products
        return ProductSearch.matching(scoped, term: term)
    }
}
