//
//  CategoryViewModel.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Observation

/// Drives one category page: top rated products first, then the rest.
@MainActor
@Observable
final class CategoryViewModel {
    let name: String
    private(set) var listing: LoadState<CategoryListing> = .idle

    private let loadCategory: LoadCategory

    init(name: String, loadCategory: LoadCategory) {
        self.name = name
        self.loadCategory = loadCategory
    }

    /// Refreshes in place: the listing already on screen stays visible while loading, and a failed refresh keeps it.
    func load() async {
        if listing.value == nil { listing = .loading }
        do {
            listing = .loaded(try await loadCategory.execute(categoryName: name))
        } catch {
            if listing.value == nil { listing = .failed(.from(error)) }
        }
    }
}
