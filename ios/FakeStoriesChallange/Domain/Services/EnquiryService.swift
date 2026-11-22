//
//  EnquiryService.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Delivers enquiries to the sales team; the email provider sits behind this.
protocol EnquiryService: Sendable {
    func submit(_ enquiry: Enquiry) async throws
}
