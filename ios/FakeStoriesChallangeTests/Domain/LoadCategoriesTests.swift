//
//  LoadCategoriesTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@Suite struct LoadCategoriesTests {

    @Test func `Categories are unique and sorted by name`() async throws {
        let products = [
            makeProduct(id: 1, category: "men"),
            makeProduct(id: 2, category: "electronics"),
            makeProduct(id: 3, category: "men"),
        ]
        let useCase = LoadCategories(repository: FakeProductRepository(products: products))

        let names = try await useCase.execute()

        #expect(names == ["electronics", "men"])
    }
}
