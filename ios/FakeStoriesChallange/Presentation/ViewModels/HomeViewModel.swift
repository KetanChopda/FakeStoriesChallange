//
//  HomeViewModel.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Observation

/// Drives the home page: featured products and category links.
@MainActor
@Observable
final class HomeViewModel {
    private(set) var featured: LoadState<[Product]> = .idle
    private(set) var categories: LoadState<[String]> = .idle

    private let loadHome: LoadHome
    private let loadCategories: LoadCategories

    init(loadHome: LoadHome, loadCategories: LoadCategories) {
        self.loadHome = loadHome
        self.loadCategories = loadCategories
    }

    /// Refreshes in place: data already on screen stays visible while loading, and a failed refresh keeps it.
    func load() async {
        if featured.value == nil { featured = .loading }
        if categories.value == nil { categories = .loading }
        do {
            featured = .loaded(try await loadHome.execute())
        } catch {
            if featured.value == nil { featured = .failed(.from(error)) }
        }
        do {
            categories = .loaded(try await loadCategories.execute())
        } catch {
            if categories.value == nil { categories = .failed(.from(error)) }
        }
    }
}
