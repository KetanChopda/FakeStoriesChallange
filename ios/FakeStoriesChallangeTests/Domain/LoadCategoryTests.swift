//
//  LoadCategoryTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@Suite struct LoadCategoryTests {

    @Test func `Category returns only products in that category`() async throws {
        let products = [
            makeProduct(id: 1, category: "jewelery"),
            makeProduct(id: 2, category: "electronics"),
        ]
        let useCase = LoadCategory(repository: FakeProductRepository(products: products))

        let listing = try await useCase.execute(categoryName: "jewelery")

        #expect(listing.topRated.map(\.id) == [1])
        #expect(listing.others.isEmpty)
    }

    @Test func `Category shows the top three rated first and the rest after`() async throws {
        let products = (1...5).map { makeProduct(id: $0, category: "men", rate: Double($0)) }
        let useCase = LoadCategory(repository: FakeProductRepository(products: products))

        let listing = try await useCase.execute(categoryName: "men")

        #expect(listing.topRated.map(\.id) == [5, 4, 3])
        #expect(listing.others.map(\.id) == [2, 1])
    }

    @Test func `Category for an unknown name returns an empty listing`() async throws {
        let useCase = LoadCategory(repository: FakeProductRepository(products: [makeProduct(id: 1)]))

        let listing = try await useCase.execute(categoryName: "missing")

        #expect(listing.topRated.isEmpty)
        #expect(listing.others.isEmpty)
    }
}
