//
//  LoadCategory.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// A category page: the best-rated products first, then the rest.
struct CategoryListing: Equatable, Sendable {
    let topRated: [Product]
    let others: [Product]
}

/// Builds the listing for one category from the full catalogue.
struct LoadCategory: Sendable {
    let repository: any ProductRepository
    let topRatedCount: Int

    init(repository: any ProductRepository, topRatedCount: Int = CatalogueRules.topRatedPerCategory) {
        self.repository = repository
        self.topRatedCount = topRatedCount
    }

    func execute(categoryName: String) async throws -> CategoryListing {
        let products = try await repository.products().filter { $0.category == categoryName }
        let ranked = ProductRanking.ranked(products)
        return CategoryListing(
            topRated: Array(ranked.prefix(topRatedCount)),
            others: Array(ranked.dropFirst(topRatedCount))
        )
    }
}
