//
//  RootView.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// Owns the navigation stack and the home view model for the app's first screen.
struct RootView: View {
    private let container: AppContainer
    @State private var home: HomeViewModel

    init(container: AppContainer) {
        self.container = container
        _home = State(initialValue: container.makeHomeViewModel())
    }

    var body: some View {
        NavigationStack {
            HomeView(viewModel: home)
                .navigationTitle(Copy.homeTitle)
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        .imageSession(container.imageSession)
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .category(let name):
            CategoryScreen(viewModel: container.makeCategoryViewModel(name: name))
        case .product, .enquiry:
            EmptyView()
        }
    }
}
