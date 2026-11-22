//
//  LoadHomeTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@Suite struct LoadHomeTests {

    @Test func `Home returns the five highest rated products`() async throws {
        let products = [1, 2, 3, 4, 5, 6, 7].map { makeProduct(id: $0, rate: Double($0)) }
        let useCase = LoadHome(repository: FakeProductRepository(products: products))

        let featured = try await useCase.execute()

        #expect(featured.map(\.id) == [7, 6, 5, 4, 3])
    }

    @Test func `Home breaks rating ties by rating count`() async throws {
        let products = [
            makeProduct(id: 1, rate: 4.5, count: 10),
            makeProduct(id: 2, rate: 4.5, count: 500),
        ]
        let useCase = LoadHome(repository: FakeProductRepository(products: products), limit: 1)

        let featured = try await useCase.execute()

        #expect(featured.map(\.id) == [2])
    }

    @Test func `Home returns every product when the catalogue is smaller than the featured count`() async throws {
        let products = [makeProduct(id: 1), makeProduct(id: 2)]
        let useCase = LoadHome(repository: FakeProductRepository(products: products))

        let featured = try await useCase.execute()

        #expect(featured.count == 2)
    }

    @Test func `Home surfaces a repository failure`() async throws {
        let useCase = LoadHome(repository: FakeProductRepository(shouldFail: true))

        await #expect(throws: FakeFailure.unavailable) {
            _ = try await useCase.execute()
        }
    }
}
