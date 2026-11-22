//
//  APIManagerTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation
import Testing
@testable import FakeStoriesChallange

extension NetworkTests {
    @Suite struct APIManagerTests {
        private let baseURL = URL(string: "https://example.test")!

        private func respond(status: Int, body: String = "") {
            StubURLProtocol.handler = { request in
                let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
                return (response, Data(body.utf8))
            }
        }

        private func makeManager() -> APIManager {
            APIManager(session: StubURLProtocol.makeSession(), baseURL: baseURL)
        }

        @Test func `Successful response decodes into the requested type`() async throws {
            respond(status: 200, body: FakeStoreFixtures.productsJSON)

            let dtos: [FakeStoreProductDTO] = try await makeManager().send(.products)

            #expect(dtos.map(\.id) == [3, 4])
        }

        @Test func `Error status surfaces as an HTTP status error`() async throws {
            respond(status: 500)

            await #expect(throws: APIError.httpStatus(500)) {
                let _: [FakeStoreProductDTO] = try await makeManager().send(.products)
            }
        }

        @Test func `Malformed body surfaces as a decoding error`() async throws {
            respond(status: 200, body: FakeStoreFixtures.malformedJSON)

            await #expect(throws: APIError.decoding) {
                let _: [FakeStoreProductDTO] = try await makeManager().send(.products)
            }
        }

        @Test func `Lost connection surfaces as an offline error`() async throws {
            StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }

            await #expect(throws: APIError.offline) {
                let _: [FakeStoreProductDTO] = try await makeManager().send(.products)
            }
        }

        @Test func `Other network failure surfaces as a transport error`() async throws {
            StubURLProtocol.handler = { _ in throw URLError(.badURL) }

            await #expect(throws: APIError.transport) {
                let _: [FakeStoreProductDTO] = try await makeManager().send(.products)
            }
        }
    }
}
