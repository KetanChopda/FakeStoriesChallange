//
//  TestFixtures.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation
@testable import FakeStoriesChallange

/// Builds products with only the fields a rule reads; keeps each test's intent visible.
func makeProduct(
    id: Int,
    category: String = "electronics",
    rate: Double = 4.0,
    count: Int = 100
) -> Product {
    Product(
        id: id,
        title: "Product \(id)",
        price: 10,
        description: "Description \(id)",
        category: category,
        imageURL: nil,
        rating: Rating(rate: rate, count: count)
    )
}

/// Builds a product with the text fields search reads; use when the wording matters.
func makeNamedProduct(
    id: Int,
    title: String,
    description: String = "",
    category: String = "electronics"
) -> Product {
    Product(
        id: id,
        title: title,
        price: 10,
        description: description,
        category: category,
        imageURL: nil,
        rating: Rating(rate: 4.0, count: 100)
    )
}
