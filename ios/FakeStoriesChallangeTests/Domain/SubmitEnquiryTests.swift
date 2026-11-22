//
//  SubmitEnquiryTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@Suite struct SubmitEnquiryTests {

    private func makeEnquiry(
        name: String = "Ada Lovelace",
        email: String = "ada@example.com",
        message: String = "Is this in stock?"
    ) -> Enquiry {
        Enquiry(
            productID: 1,
            contact: ContactDetails(name: name, email: email, phone: nil),
            message: message
        )
    }

    @Test func `Valid enquiry is passed to the enquiry service`() async throws {
        let service = RecordingEnquiryService()
        let useCase = SubmitEnquiry(service: service)
        let enquiry = makeEnquiry()

        try await useCase.execute(enquiry)

        #expect(await service.submitted == [enquiry])
    }

    @Test(arguments: ["", "   "])
    func `Enquiry rejects a blank name`(name: String) async throws {
        let service = RecordingEnquiryService()
        let useCase = SubmitEnquiry(service: service)

        await #expect(throws: EnquiryValidationError.emptyName) {
            try await useCase.execute(makeEnquiry(name: name))
        }
        #expect(await service.submitted.isEmpty)
    }

    @Test(arguments: ["", "no-at-sign", "ada@", "@example.com", "ada@example"])
    func `Enquiry rejects a malformed email`(email: String) async throws {
        let service = RecordingEnquiryService()
        let useCase = SubmitEnquiry(service: service)

        await #expect(throws: EnquiryValidationError.invalidEmail) {
            try await useCase.execute(makeEnquiry(email: email))
        }
        #expect(await service.submitted.isEmpty)
    }

    @Test func `Enquiry rejects a blank message`() async throws {
        let service = RecordingEnquiryService()
        let useCase = SubmitEnquiry(service: service)

        await #expect(throws: EnquiryValidationError.emptyMessage) {
            try await useCase.execute(makeEnquiry(message: "  "))
        }
        #expect(await service.submitted.isEmpty)
    }
}
