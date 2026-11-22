//
//  CatalogueErrorMappingTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@Suite struct CatalogueErrorMappingTests {

    @Test func `Offline API error maps to offline`() {
        #expect(CatalogueError(APIError.offline) == .offline)
    }

    @Test func `Server error status maps to server`() {
        #expect(CatalogueError(APIError.httpStatus(503)) == .server)
    }

    @Test func `Undecodable body maps to server`() {
        #expect(CatalogueError(APIError.decoding) == .server)
    }

    @Test func `Client error status maps to unknown`() {
        #expect(CatalogueError(APIError.httpStatus(404)) == .unknown)
    }

    @Test func `Other transport failure maps to unknown`() {
        #expect(CatalogueError(APIError.transport) == .unknown)
    }
}
