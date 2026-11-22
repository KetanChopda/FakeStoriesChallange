//
//  SearchViewModel.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation
import Observation

/// Searches as the user types; a category scope limits the search to that category.
@MainActor
@Observable
final class SearchViewModel {
    var query = "" {
        didSet { scheduleSearch() }
    }
    private(set) var results: LoadState<[Product]> = .idle
    /// The search waiting out the debounce or running now; tests await it to observe the result.
    private(set) var pendingSearch: Task<Void, Never>?

    private let searchProducts: SearchProducts
    private let categoryName: String?
    private let debounce: Duration

    init(searchProducts: SearchProducts, categoryName: String? = nil, debounce: Duration = Timing.searchDebounce) {
        self.searchProducts = searchProducts
        self.categoryName = categoryName
        self.debounce = debounce
    }

    /// Each keystroke restarts the wait, so only the query the user pauses on reaches the repository.
    private func scheduleSearch() {
        pendingSearch?.cancel()
        pendingSearch = Task { [debounce] in
            try? await Task.sleep(for: debounce)
            guard !Task.isCancelled else { return }
            await search()
        }
    }

    /// Runs the search now; a search cancelled by a newer keystroke leaves the results alone.
    func search() async {
        results = .loading
        do {
            let products = try await searchProducts.execute(ProductQuery(term: query, categoryName: categoryName))
            guard !Task.isCancelled else { return }
            results = .loaded(products)
        } catch {
            guard !Task.isCancelled else { return }
            results = .failed(.from(error))
        }
    }
}
