//
//  HomeView.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// Home page: category links, then the top rated products.
struct HomeView: View {
    let viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                LoadStateView(state: viewModel.categories, retry: { await viewModel.load() }) { names in
                    if !names.isEmpty {
                        categoryLinks(names)
                    }
                }

                LoadStateView(state: viewModel.featured, retry: { await viewModel.load() }) { products in
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text(Copy.featuredTitle)
                            .font(.title2)
                            .padding(.horizontal, Theme.Spacing.medium)
                        if products.isEmpty {
                            ContentUnavailableView {
                                Label(Copy.noProducts, systemImage: Theme.Symbol.empty)
                            }
                        } else {
                            ProductGrid(products: products)
                        }
                    }
                }
            }
            .padding(.vertical, Theme.Spacing.medium)
        }
        .task { await viewModel.load() }
    }

    private func categoryLinks(_ names: [String]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: Theme.Spacing.small) {
                ForEach(names, id: \.self) { name in
                    NavigationLink(value: Route.category(name: name)) {
                        Text(name.capitalized)
                            .padding(.horizontal, Theme.Spacing.medium)
                            .padding(.vertical, Theme.Spacing.small)
                            .background(.quaternary, in: .capsule)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.Spacing.medium)
        }
        .scrollIndicators(.hidden)
    }
}
