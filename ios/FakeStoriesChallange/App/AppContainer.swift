//
//  AppContainer.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Composition root: the only place concrete data sources are chosen and wired to use cases.
final class AppContainer: Sendable {
    private let productRepository: any ProductRepository
    private let enquiryService: any EnquiryService
    let imageSession: URLSession

    init(productRepository: any ProductRepository, enquiryService: any EnquiryService, imageSession: URLSession) {
        self.productRepository = productRepository
        self.enquiryService = enquiryService
        self.imageSession = imageSession
    }

    static func live() -> AppContainer {
        AppContainer(
            productRepository: FakeStoreProductRepository(api: APIManager()),
            enquiryService: StubEnquiryService(),
            imageSession: ImageSession.make()
        )
    }

    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            loadHome: LoadHome(repository: productRepository),
            loadCategories: LoadCategories(repository: productRepository)
        )
    }

    @MainActor
    func makeCategoryViewModel(name: String) -> CategoryViewModel {
        CategoryViewModel(name: name, loadCategory: LoadCategory(repository: productRepository))
    }

    @MainActor
    func makeProductDetailViewModel(id: Int) -> ProductDetailViewModel {
        ProductDetailViewModel(productID: id, repository: productRepository)
    }

    @MainActor
    func makeSearchViewModel(categoryName: String? = nil) -> SearchViewModel {
        SearchViewModel(searchProducts: SearchProducts(repository: productRepository), categoryName: categoryName)
    }
}
