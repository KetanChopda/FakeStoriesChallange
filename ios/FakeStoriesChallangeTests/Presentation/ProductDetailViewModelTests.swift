//
//  ProductDetailViewModelTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@MainActor
@Suite struct ProductDetailViewModelTests {

    @Test func `Product detail loads the selected product`() async throws {
        let viewModel = ProductDetailViewModel(
            productID: 2,
            repository: FakeProductRepository(products: [makeProduct(id: 1), makeProduct(id: 2)])
        )

        await viewModel.load()

        #expect(viewModel.product.value?.id == 2)
    }

    @Test func `Product detail shows a failure for an unknown product`() async throws {
        let viewModel = ProductDetailViewModel(productID: 9, repository: FakeProductRepository(products: [makeProduct(id: 1)]))

        await viewModel.load()

        #expect(viewModel.product == .failed(.unknown))
    }

    @Test func `Product detail reports an offline failure when the network is unreachable`() async throws {
        let viewModel = ProductDetailViewModel(productID: 1, repository: FakeProductRepository(failure: .offline))

        await viewModel.load()

        #expect(viewModel.product == .failed(.offline))
    }

    @Test func `Product detail keeps the product when a refresh fails`() async throws {
        let repository = FlakyProductRepository(catalogue: [makeProduct(id: 1)])
        let viewModel = ProductDetailViewModel(productID: 1, repository: repository)
        await viewModel.load()

        await repository.setShouldFail(true)
        await viewModel.load()

        #expect(viewModel.product.value?.id == 1)
    }
}
