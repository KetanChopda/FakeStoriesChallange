//
//  FakeStoreProductRepositoryTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation
import Testing
@testable import FakeStoriesChallange

extension NetworkTests {
    @Suite struct FakeStoreProductRepositoryTests {
        private let baseURL = URL(string: "https://example.test")!

        private func makeRepository() -> FakeStoreProductRepository {
            FakeStoreProductRepository(api: APIManager(session: StubURLProtocol.makeSession(), baseURL: baseURL))
        }

        @Test func `Repository maps Fake Store products into domain products`() async throws {
            StubURLProtocol.handler = { request in
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, Data(FakeStoreFixtures.productsJSON.utf8))
            }

            let products = try await makeRepository().products()

            let first = try #require(products.first)
            #expect(first.id == 3)
            #expect(first.title == "Backpack")
            #expect(first.category == "men's clothing")
            #expect(first.imageURL == URL(string: "https://fakestoreapi.com/img/3.jpg"))
            #expect(first.rating == Rating(rate: 3.9, count: 120))
        }

        @Test func `Repository fetches one product by id`() async throws {
            StubURLProtocol.handler = { request in
                #expect(request.url?.absoluteString == "https://example.test/products/3")
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, Data(FakeStoreFixtures.singleProductJSON.utf8))
            }

            let product = try await makeRepository().product(id: 3)

            #expect(product.id == 3)
        }

        @Test func `Offline failure reaches the app as an offline catalogue error`() async throws {
            StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }

            await #expect(throws: CatalogueError.offline) {
                _ = try await makeRepository().products()
            }
        }

        @Test func `Server failure reaches the app as a server catalogue error`() async throws {
            StubURLProtocol.handler = { request in
                let response = HTTPURLResponse(url: request.url!, statusCode: 503, httpVersion: nil, headerFields: nil)!
                return (response, Data())
            }

            await #expect(throws: CatalogueError.server) {
                _ = try await makeRepository().products()
            }
        }
    }
}
