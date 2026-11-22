//
//  ProductDetailViewModel.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Observation

/// Drives the product details page for one product.
@MainActor
@Observable
final class ProductDetailViewModel {
    let productID: Int
    private(set) var product: LoadState<Product> = .idle

    private let repository: any ProductRepository

    init(productID: Int, repository: any ProductRepository) {
        self.productID = productID
        self.repository = repository
    }

    /// Refreshes in place: the product on screen stays visible while loading, and a failed refresh keeps it.
    func load() async {
        if product.value == nil { product = .loading }
        do {
            product = .loaded(try await repository.product(id: productID))
        } catch {
            if product.value == nil { product = .failed(.from(error)) }
        }
    }
}
