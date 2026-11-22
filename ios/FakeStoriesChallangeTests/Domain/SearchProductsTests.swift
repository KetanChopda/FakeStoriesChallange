//
//  SearchProductsTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@Suite struct SearchProductsTests {

    private let catalogue = [
        makeNamedProduct(id: 1, title: "Leather Backpack", description: "Fits a laptop"),
        makeNamedProduct(id: 2, title: "Silver Ring", description: "Sterling", category: "jewelery"),
        makeNamedProduct(id: 3, title: "Hoodie", description: "Warm BACKPACK-friendly fabric"),
    ]

    @Test func `Search matches title and description regardless of case`() async throws {
        let useCase = SearchProducts(repository: FakeProductRepository(products: catalogue))

        let results = try await useCase.execute(ProductQuery(term: "backpack"))

        #expect(results.map(\.id) == [1, 3])
    }

    @Test func `Search matches the category name`() async throws {
        let useCase = SearchProducts(repository: FakeProductRepository(products: catalogue))

        let results = try await useCase.execute(ProductQuery(term: "jewelery"))

        #expect(results.map(\.id) == [2])
    }

    @Test func `Search with no matching product returns nothing`() async throws {
        let useCase = SearchProducts(repository: FakeProductRepository(products: catalogue))

        let results = try await useCase.execute(ProductQuery(term: "kettle"))

        #expect(results.isEmpty)
    }

    @Test(arguments: ["", "   "])
    func `Blank search returns nothing`(term: String) async throws {
        let useCase = SearchProducts(repository: FakeProductRepository(products: catalogue))

        let results = try await useCase.execute(ProductQuery(term: term))

        #expect(results.isEmpty)
    }

    @Test func `Search inside a category only returns matching products from that category`() async throws {
        let products = [
            makeNamedProduct(id: 1, title: "Backpack", category: "electronics"),
            makeNamedProduct(id: 2, title: "Backpack", category: "men's clothing"),
        ]
        let useCase = SearchProducts(repository: FakeProductRepository(products: products))

        let results = try await useCase.execute(ProductQuery(term: "backpack", categoryName: "men's clothing"))

        #expect(results.map(\.id) == [2])
    }

    @Test func `Search inside a category returns nothing when no product in it matches`() async throws {
        let products = [makeNamedProduct(id: 1, title: "Backpack", category: "electronics")]
        let useCase = SearchProducts(repository: FakeProductRepository(products: products))

        let results = try await useCase.execute(ProductQuery(term: "backpack", categoryName: "jewelery"))

        #expect(results.isEmpty)
    }
}
