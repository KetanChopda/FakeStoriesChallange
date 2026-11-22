//
//  ProductRanking.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Orders products by quality so every screen ranks the same way.
enum ProductRanking {
    /// Highest rating first; ties go to the higher rating count, then the lower id for a stable order.
    static func ranked(_ products: [Product]) -> [Product] {
        products.sorted { lhs, rhs in
            if lhs.rating.rate != rhs.rating.rate { return lhs.rating.rate > rhs.rating.rate }
            if lhs.rating.count != rhs.rating.count { return lhs.rating.count > rhs.rating.count }
            return lhs.id < rhs.id
        }
    }
}
