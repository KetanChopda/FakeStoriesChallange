//
//  Fakes.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation
@testable import FakeStoriesChallange

enum FakeFailure: Error, Equatable {
    case unavailable
}

/// In-memory catalogue; set `shouldFail` to simulate a broken data source.
struct FakeProductRepository: ProductRepository {
    var products: [Product] = []
    var shouldFail = false
    var failure: CatalogueError?

    func products() async throws -> [Product] {
        if let failure { throw failure }
        if shouldFail { throw FakeFailure.unavailable }
        return products
    }

    func product(id: Int) async throws -> Product {
        if let failure { throw failure }
        if shouldFail { throw FakeFailure.unavailable }
        guard let match = products.first(where: { $0.id == id }) else {
            throw FakeFailure.unavailable
        }
        return match
    }
}

/// Records submitted enquiries so tests can assert what reached the service.
actor RecordingEnquiryService: EnquiryService {
    private(set) var submitted: [Enquiry] = []

    func submit(_ enquiry: Enquiry) async throws {
        submitted.append(enquiry)
    }
}

/// Serves a catalogue that can start failing after a first successful load, to test refresh.
actor FlakyProductRepository: ProductRepository {
    private let catalogue: [Product]
    private var shouldFail = false

    init(catalogue: [Product]) {
        self.catalogue = catalogue
    }

    func setShouldFail(_ value: Bool) {
        shouldFail = value
    }

    func products() async throws -> [Product] {
        if shouldFail { throw FakeFailure.unavailable }
        return catalogue
    }

    func product(id: Int) async throws -> Product {
        if shouldFail { throw FakeFailure.unavailable }
        guard let match = catalogue.first(where: { $0.id == id }) else { throw FakeFailure.unavailable }
        return match
    }
}

/// Always fails to send with the given error, so tests can check how the UI reports it.
struct FailingEnquiryService: EnquiryService {
    var failure: CatalogueError = .unknown

    func submit(_ enquiry: Enquiry) async throws {
        throw failure
    }
}

/// Holds each send until the test releases it, so the in-flight state can be observed.
actor GatedEnquiryService: EnquiryService {
    private var entered = false
    private var continuation: CheckedContinuation<Void, Never>?

    func submit(_ enquiry: Enquiry) async throws {
        entered = true
        await withCheckedContinuation { continuation = $0 }
    }

    /// Polls until a send has started; the send sets the flag before it suspends.
    func waitUntilEntered() async {
        while !entered { await Task.yield() }
    }

    func release() {
        continuation?.resume()
        continuation = nil
    }
}

/// Counts how many times the catalogue was requested, so tests can check debouncing.
actor CountingProductRepository: ProductRepository {
    private let catalogue: [Product]
    private(set) var requests = 0

    init(catalogue: [Product]) {
        self.catalogue = catalogue
    }

    func products() async throws -> [Product] {
        requests += 1
        return catalogue
    }

    func product(id: Int) async throws -> Product {
        requests += 1
        guard let match = catalogue.first(where: { $0.id == id }) else { throw FakeFailure.unavailable }
        return match
    }
}
