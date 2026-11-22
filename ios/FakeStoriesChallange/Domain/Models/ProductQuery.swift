//
//  ProductQuery.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// What the user is looking for; new filters (price, sort) are added here, not as new use case parameters.
struct ProductQuery: Equatable, Sendable {
    let term: String
    let categoryName: String?

    init(term: String, categoryName: String? = nil) {
        self.term = term
        self.categoryName = categoryName
    }
}
