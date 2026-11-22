//
//  CategoryScreen.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// One category: its top rated products first, then the rest; typing filters within the category.
struct CategoryScreen: View {
    @State private var viewModel: CategoryViewModel
    @State private var search: SearchViewModel

    init(viewModel: CategoryViewModel, search: SearchViewModel) {
        _viewModel = State(initialValue: viewModel)
        _search = State(initialValue: search)
    }

    var body: some View {
        @Bindable var searchModel = search
        Group {
            if search.query.isEmpty {
                ScrollView {
                    LoadStateView(state: viewModel.listing, retry: { await viewModel.load() }) { listing in
                        content(for: listing)
                    }
                }
            } else {
                SearchResultsView(viewModel: search)
            }
        }
        .navigationTitle(viewModel.name.capitalized)
        .searchable(text: $searchModel.query, prompt: Copy.searchPrompt(in: viewModel.name.capitalized))
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private func content(for listing: CategoryListing) -> some View {
        if listing.topRated.isEmpty && listing.others.isEmpty {
            ContentUnavailableView {
                Label(Copy.noCategoryProducts, systemImage: Theme.Symbol.empty)
            }
        } else {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                if !listing.topRated.isEmpty {
                    Text(Copy.featuredTitle)
                        .font(.title2)
                        .padding(.horizontal, Theme.Spacing.medium)
                    ProductGrid(products: listing.topRated)
                }
                if !listing.others.isEmpty {
                    Text(Copy.moreInCategoryTitle)
                        .font(.title2)
                        .padding(.horizontal, Theme.Spacing.medium)
                    ProductGrid(products: listing.others)
                }
            }
            .padding(.vertical, Theme.Spacing.medium)
        }
    }
}
