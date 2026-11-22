//
//  ProductDetailScreen.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// One product: image, title, price, description, and the enquiry entry point.
struct ProductDetailScreen: View {
    @State private var viewModel: ProductDetailViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    init(viewModel: ProductDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LoadStateView(state: viewModel.product, retry: { await viewModel.load() }) { product in
                details(for: product)
            }
        }
        .task { await viewModel.load() }
    }

    /// Side by side when there is width to spare (regular size class, iPad and Duo open), stacked otherwise.
    @ViewBuilder
    private func details(for product: Product) -> some View {
        let layout = horizontalSizeClass == .regular
            ? AnyLayout(HStackLayout(alignment: .top, spacing: Theme.Spacing.large))
            : AnyLayout(VStackLayout(alignment: .leading, spacing: Theme.Spacing.large))

        layout {
            RemoteImage(url: product.imageURL)
                .frame(maxWidth: .infinity, maxHeight: Theme.Grid.detailImageHeight)

            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                Text(product.title)
                    .font(.title2)
                Text(product.price, format: .currency(code: Theme.Currency.code))
                    .font(.title3)
                Text(product.description)
                    .font(.body)
                NavigationLink(value: Route.enquiry(productID: product.id)) {
                    Text(Copy.enquire)
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Theme.Spacing.medium)
    }
}
