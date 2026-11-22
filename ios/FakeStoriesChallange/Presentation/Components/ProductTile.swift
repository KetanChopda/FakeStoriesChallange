//
//  ProductTile.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// One product in a grid: image, title, and price.
struct ProductTile: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            RemoteImage(url: product.imageURL)
                .frame(height: Theme.Grid.imageHeight)

            Text(product.title)
                .font(.headline)
                .lineLimit(2, reservesSpace: true)
            Text(product.price, format: .currency(code: Theme.Currency.code))
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
