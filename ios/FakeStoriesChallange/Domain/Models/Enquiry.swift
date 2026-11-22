//
//  Enquiry.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

struct ContactDetails: Equatable, Sendable {
    let name: String
    let email: String
    let phone: String?
}

struct Enquiry: Equatable, Sendable {
    let productID: Int
    let contact: ContactDetails
    let message: String
}

enum EnquiryValidationError: Error, Equatable {
    case emptyName
    case invalidEmail
    case emptyMessage
}
