//
//  HomeViewModelTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@MainActor
@Suite struct HomeViewModelTests {

    @Test func `Home loads the featured products`() async throws {
        let products = (1...6).map { makeProduct(id: $0, rate: Double($0)) }
        let repository = FakeProductRepository(products: products)
        let viewModel = HomeViewModel(loadHome: LoadHome(repository: repository), loadCategories: LoadCategories(repository: repository))

        await viewModel.load()

        #expect(viewModel.featured.value?.map(\.id) == [6, 5, 4, 3, 2])
    }

    @Test func `Home loads the category names`() async throws {
        let products = [makeProduct(id: 1, category: "men"), makeProduct(id: 2, category: "women")]
        let repository = FakeProductRepository(products: products)
        let viewModel = HomeViewModel(loadHome: LoadHome(repository: repository), loadCategories: LoadCategories(repository: repository))

        await viewModel.load()

        #expect(viewModel.categories.value == ["men", "women"])
    }

    @Test func `Home shows a failure when the catalogue cannot load`() async throws {
        let repository = FakeProductRepository(shouldFail: true)
        let viewModel = HomeViewModel(loadHome: LoadHome(repository: repository), loadCategories: LoadCategories(repository: repository))

        await viewModel.load()

        #expect(viewModel.featured == .failed(.unknown))
        #expect(viewModel.categories == .failed(.unknown))
    }

    @Test func `Home reports an offline failure when the network is unreachable`() async throws {
        let repository = FakeProductRepository(failure: .offline)
        let viewModel = HomeViewModel(loadHome: LoadHome(repository: repository), loadCategories: LoadCategories(repository: repository))

        await viewModel.load()

        #expect(viewModel.featured == .failed(.offline))
        #expect(viewModel.categories == .failed(.offline))
    }

    @Test func `Home keeps showing loaded products when a refresh fails`() async throws {
        let repository = FlakyProductRepository(catalogue: [makeProduct(id: 1, rate: 4.5)])
        let viewModel = HomeViewModel(loadHome: LoadHome(repository: repository), loadCategories: LoadCategories(repository: repository))
        await viewModel.load()

        await repository.setShouldFail(true)
        await viewModel.load()

        #expect(viewModel.featured.value?.map(\.id) == [1])
    }

    @Test func `Home treats an empty catalogue as loaded, not failed`() async throws {
        let repository = FakeProductRepository(products: [])
        let viewModel = HomeViewModel(loadHome: LoadHome(repository: repository), loadCategories: LoadCategories(repository: repository))

        await viewModel.load()

        #expect(viewModel.featured.value == [])
        #expect(viewModel.categories.value == [])
    }
}
