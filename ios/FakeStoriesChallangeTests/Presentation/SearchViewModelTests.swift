//
//  SearchViewModelTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@MainActor
@Suite struct SearchViewModelTests {

    private let catalogue = [
        makeNamedProduct(id: 1, title: "Backpack"),
        makeNamedProduct(id: 2, title: "Kettle"),
    ]

    @Test func `Search shows the products matching the query`() async throws {
        let viewModel = SearchViewModel(searchProducts: SearchProducts(repository: FakeProductRepository(products: catalogue)))

        viewModel.query = "back"
        await viewModel.search()

        #expect(viewModel.results.value?.map(\.id) == [1])
    }

    @Test func `Blank query shows no results without searching`() async throws {
        let viewModel = SearchViewModel(searchProducts: SearchProducts(repository: FakeProductRepository(products: catalogue)))

        viewModel.query = "  "
        await viewModel.search()

        #expect(viewModel.results.value == [])
    }

    @Test func `A query with no matches loads as empty, not failed`() async throws {
        let viewModel = SearchViewModel(searchProducts: SearchProducts(repository: FakeProductRepository(products: catalogue)))

        viewModel.query = "sofa"
        await viewModel.search()

        #expect(viewModel.results.value == [])
    }

    @Test func `Search reports an offline failure when the network is unreachable`() async throws {
        let viewModel = SearchViewModel(searchProducts: SearchProducts(repository: FakeProductRepository(failure: .offline)))

        viewModel.query = "back"
        await viewModel.search()

        #expect(viewModel.results == .failed(.offline))
    }

    @Test func `Scoped search only searches within its category`() async throws {
        let products = [
            makeNamedProduct(id: 1, title: "Backpack", category: "electronics"),
            makeNamedProduct(id: 2, title: "Backpack", category: "men's clothing"),
        ]
        let viewModel = SearchViewModel(
            searchProducts: SearchProducts(repository: FakeProductRepository(products: products)),
            categoryName: "men's clothing"
        )

        viewModel.query = "backpack"
        await viewModel.search()

        #expect(viewModel.results.value?.map(\.id) == [2])
    }

    @Test func `Typing quickly runs one search after the user pauses`() async throws {
        let repository = CountingProductRepository(catalogue: catalogue)
        let viewModel = SearchViewModel(searchProducts: SearchProducts(repository: repository), debounce: .milliseconds(20))

        viewModel.query = "b"
        viewModel.query = "ba"
        viewModel.query = "back"
        await viewModel.pendingSearch?.value

        #expect(await repository.requests == 1)
        #expect(viewModel.results.value?.map(\.id) == [1])
    }

    @Test func `A blank query never reaches the repository`() async throws {
        let repository = CountingProductRepository(catalogue: catalogue)
        let viewModel = SearchViewModel(searchProducts: SearchProducts(repository: repository), debounce: .milliseconds(20))

        viewModel.query = "   "
        await viewModel.pendingSearch?.value

        #expect(await repository.requests == 0)
        #expect(viewModel.results.value == [])
    }
}
