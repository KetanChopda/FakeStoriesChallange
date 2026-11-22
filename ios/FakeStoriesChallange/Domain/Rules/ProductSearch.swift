//
//  ProductSearch.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Matches products by text so search results are the same on every screen.
enum ProductSearch {
    static func matching(_ products: [Product], term: String) -> [Product] {
        products.filter { product in
            product.title.localizedCaseInsensitiveContains(term)
                || product.description.localizedCaseInsensitiveContains(term)
                || product.category.localizedCaseInsensitiveContains(term)
        }
    }
}
