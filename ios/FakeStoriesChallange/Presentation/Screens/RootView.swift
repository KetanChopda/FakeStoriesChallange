//
//  RootView.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// Owns the navigation stack, the home view model and the search view model for the app's first screen.
struct RootView: View {
    private let container: AppContainer
    @State private var home: HomeViewModel
    @State private var search: SearchViewModel

    init(container: AppContainer) {
        self.container = container
        _home = State(initialValue: container.makeHomeViewModel())
        _search = State(initialValue: container.makeSearchViewModel())
    }

    var body: some View {
        @Bindable var searchModel = search
        NavigationStack {
            Group {
                if search.query.isEmpty {
                    HomeView(viewModel: home)
                } else {
                    SearchResultsView(viewModel: search)
                }
            }
            .navigationTitle(search.query.isEmpty ? Copy.homeTitle : Copy.searchTitle)
            .navigationDestination(for: Route.self) { route in
                destination(for: route)
            }
            .searchable(text: $searchModel.query, prompt: Copy.searchPrompt)
        }
        .imageSession(container.imageSession)
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .category(let name):
            CategoryScreen(
                viewModel: container.makeCategoryViewModel(name: name),
                search: container.makeSearchViewModel(categoryName: name)
            )
        case .product(let id):
            ProductDetailScreen(viewModel: container.makeProductDetailViewModel(id: id))
        case .enquiry(let productID):
            EnquiryScreen(viewModel: container.makeEnquiryViewModel(productID: productID))
        }
    }
}
