//
//  BackendProductRepository.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Product source that reads the catalogue from the backend through APIManager.
struct BackendProductRepository: ProductRepository {
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
