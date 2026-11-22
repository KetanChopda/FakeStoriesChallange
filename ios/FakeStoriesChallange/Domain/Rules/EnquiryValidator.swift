//
//  EnquiryValidator.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Rejects an enquiry before it reaches the service; keeps invalid data out of the pipeline.
enum EnquiryValidator {
    static func validate(_ enquiry: Enquiry) throws(EnquiryValidationError) {
        if enquiry.contact.name.trimmed.isEmpty { throw .emptyName }
        if !isValidEmail(enquiry.contact.email) { throw .invalidEmail }
        if enquiry.message.trimmed.isEmpty { throw .emptyMessage }
    }

    private static func isValidEmail(_ email: String) -> Bool {
        email.wholeMatch(of: EnquiryRules.emailPattern) != nil
    }
}

enum EnquiryRules {
    /// Computed so the regex is not shared mutable state under strict concurrency.
    static var emailPattern: Regex<Substring> { /[^@\s]+@[^@\s]+\.[^@\s]+/ }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
