//
//  FakeStoreProductDTO.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Wire shape of a Fake Store product; never leaves the Data layer.
struct FakeStoreProductDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let price: Decimal
    let description: String
    let category: String
    let image: URL
    let rating: RatingDTO

    struct RatingDTO: Decodable, Sendable {
        let rate: Double
        let count: Int
    }

    var product: Product {
        Product(
            id: id,
            title: title,
            price: price,
            description: description,
            category: category,
            imageURL: image,
            rating: Rating(rate: rating.rate, count: rating.count)
        )
    }
}
