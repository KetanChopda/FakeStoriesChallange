//
//  SearchResultsView.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// Results for the current query; no match and failures each get their own explanation.
struct SearchResultsView: View {
    let viewModel: SearchViewModel

    var body: some View {
        ScrollView {
            if case .idle = viewModel.results {
                ContentUnavailableView {
                    Label(Copy.searchHint, systemImage: Theme.Symbol.search)
                }
            } else {
                LoadStateView(state: viewModel.results, retry: { await viewModel.search() }) { products in
                    if products.isEmpty {
                        ContentUnavailableView.search(text: viewModel.query)
                    } else {
                        ProductGrid(products: products)
                            .padding(.vertical, Theme.Spacing.medium)
                    }
                }
            }
        }
    }
}
