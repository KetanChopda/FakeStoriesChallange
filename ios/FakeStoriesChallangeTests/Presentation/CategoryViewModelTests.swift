//
//  CategoryViewModelTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@MainActor
@Suite struct CategoryViewModelTests {

    @Test func `Category loads its top rated products and the rest`() async throws {
        let products = (1...4).map { makeProduct(id: $0, category: "men", rate: Double($0)) }
        let viewModel = CategoryViewModel(
            name: "men",
            loadCategory: LoadCategory(repository: FakeProductRepository(products: products), topRatedCount: 2)
        )

        await viewModel.load()

        #expect(viewModel.listing.value?.topRated.map(\.id) == [4, 3])
        #expect(viewModel.listing.value?.others.map(\.id) == [2, 1])
    }

    @Test func `Category shows a failure when the catalogue cannot load`() async throws {
        let viewModel = CategoryViewModel(
            name: "men",
            loadCategory: LoadCategory(repository: FakeProductRepository(shouldFail: true))
        )

        await viewModel.load()

        #expect(viewModel.listing == .failed(.unknown))
    }

    @Test func `Category reports a server failure as a server error`() async throws {
        let viewModel = CategoryViewModel(
            name: "men",
            loadCategory: LoadCategory(repository: FakeProductRepository(failure: .server))
        )

        await viewModel.load()

        #expect(viewModel.listing == .failed(.server))
    }

    @Test func `Category keeps showing its listing when a refresh fails`() async throws {
        let repository = FlakyProductRepository(catalogue: [makeProduct(id: 1, category: "men")])
        let viewModel = CategoryViewModel(name: "men", loadCategory: LoadCategory(repository: repository))
        await viewModel.load()

        await repository.setShouldFail(true)
        await viewModel.load()

        #expect(viewModel.listing.value?.topRated.map(\.id) == [1])
    }

    @Test func `Category with no products is loaded empty, not failed`() async throws {
        let viewModel = CategoryViewModel(name: "men", loadCategory: LoadCategory(repository: FakeProductRepository(products: [])))

        await viewModel.load()

        #expect(viewModel.listing.value?.topRated == [])
        #expect(viewModel.listing.value?.others == [])
    }
}
