//
//  APIEndpointTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation
import Testing
@testable import FakeStoriesChallange

@Suite struct APIEndpointTests {
    private let baseURL = URL(string: "https://example.test")!

    @Test func `Products endpoint builds the collection URL`() {
        let request = APIEndpoint.products.request(baseURL: baseURL)

        #expect(request.url?.absoluteString == "https://example.test/products")
        #expect(request.httpMethod == "GET")
    }

    @Test func `Product endpoint builds the item URL from its id`() {
        let request = APIEndpoint.product(id: 3).request(baseURL: baseURL)

        #expect(request.url?.absoluteString == "https://example.test/products/3")
    }
}
