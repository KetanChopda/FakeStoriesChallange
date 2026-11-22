//
//  Product.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// A catalogue item as the app understands it, independent of any wire format.
struct Product: Equatable, Identifiable, Sendable {
    let id: Int
    let title: String
    let price: Decimal
    let description: String
    let category: String
    let imageURL: URL?
    let rating: Rating
}

struct Rating: Equatable, Sendable {
    let rate: Double
    let count: Int
}
