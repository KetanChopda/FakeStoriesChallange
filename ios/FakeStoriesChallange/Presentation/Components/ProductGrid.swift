//
//  ProductGrid.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// Adaptive grid of product tiles; column count follows the available width, so it suits Duo and split view.
struct ProductGrid: View {
    let products: [Product]

    private let columns = [GridItem(.adaptive(minimum: Theme.Grid.minimumTileWidth), spacing: Theme.Spacing.medium)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Theme.Spacing.medium) {
            ForEach(products) { product in
                NavigationLink(value: Route.product(id: product.id)) {
                    ProductTile(product: product)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Theme.Spacing.medium)
    }
}
