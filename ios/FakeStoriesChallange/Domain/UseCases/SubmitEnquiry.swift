//
//  SubmitEnquiry.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Validates an enquiry, then hands it to the service; invalid input never leaves the device.
struct SubmitEnquiry: Sendable {
    let service: any EnquiryService

    func execute(_ enquiry: Enquiry) async throws {
        try EnquiryValidator.validate(enquiry)
        try await service.submit(enquiry)
    }
}
