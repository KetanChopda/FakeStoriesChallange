//
//  FakeStoreProductRepository.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Temporary product source that calls Fake Store through APIManager.
/// Phase 2 swaps this for a backend-backed repository; the brief forbids direct client calls long term.
struct FakeStoreProductRepository: ProductRepository {
    let api: APIManager

    func products() async throws -> [Product] {
        do {
            let dtos: [FakeStoreProductDTO] = try await api.send(.products)
            return dtos.map(\.product)
        } catch let error as APIError {
            throw CatalogueError(error)
        }
    }

    func product(id: Int) async throws -> Product {
        do {
            let dto: FakeStoreProductDTO = try await api.send(.product(id: id))
            return dto.product
        } catch let error as APIError {
            throw CatalogueError(error)
        }
    }
}
