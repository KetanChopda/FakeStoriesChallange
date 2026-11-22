//
//  LoadHome.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Returns the products shown on the home page, highest rated first.
struct LoadHome: Sendable {
    let repository: any ProductRepository
    let limit: Int

    init(repository: any ProductRepository, limit: Int = CatalogueRules.featuredCount) {
        self.repository = repository
        self.limit = limit
    }

    func execute() async throws -> [Product] {
        let products = try await repository.products()
        return Array(ProductRanking.ranked(products).prefix(limit))
    }
}
