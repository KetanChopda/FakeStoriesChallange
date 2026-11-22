//
//  StubEnquiryService.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Phase 1 stand-in: accepts every valid enquiry. Phase 2 posts it to the backend.
struct StubEnquiryService: EnquiryService {
    func submit(_ enquiry: Enquiry) async throws {}
}
