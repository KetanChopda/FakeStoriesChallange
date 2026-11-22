//
//  BackendEnquiryServiceTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation
import Testing
@testable import FakeStoriesChallange

extension NetworkTests {
    @Suite struct BackendEnquiryServiceTests {
        private let baseURL = URL(string: "https://example.test")!

        private var enquiry: Enquiry {
            Enquiry(
                productID: 3,
                contact: ContactDetails(name: "Ada Lovelace", email: "ada@example.com", phone: nil),
                message: "Is this in stock?"
            )
        }

        private func makeService() -> BackendEnquiryService {
            BackendEnquiryService(api: APIManager(session: StubURLProtocol.makeSession(), baseURL: baseURL))
        }

        private func respond(status: Int, body: String) {
            StubURLProtocol.handler = { request in
                let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
                return (response, Data(body.utf8))
            }
        }

        @Test func `Accepted enquiry completes without error`() async throws {
            respond(status: 201, body: #"{"status":"received"}"#)

            try await makeService().submit(enquiry)
        }

        @Test func `Backend mail failure surfaces as a server error`() async throws {
            respond(status: 502, body: #"{"error":{"code":"enquiry_not_sent","message":"We could not send."}}"#)

            await #expect(throws: CatalogueError.server) {
                try await makeService().submit(enquiry)
            }
        }

        @Test func `Lost connection surfaces as an offline error`() async throws {
            StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }

            await #expect(throws: CatalogueError.offline) {
                try await makeService().submit(enquiry)
            }
        }
    }
}
