//
//  EnquiryDTO.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Wire shape of an enquiry sent to POST /enquiries; optional fields are omitted when absent.
struct EnquiryRequestDTO: Encodable, Sendable {
    let productId: Int
    let name: String
    let email: String
    let phone: String?
    let message: String

    init(_ enquiry: Enquiry) {
        productId = enquiry.productID
        name = enquiry.contact.name
        email = enquiry.contact.email
        phone = enquiry.contact.phone
        message = enquiry.message
    }
}

/// The backend's reply to an accepted enquiry.
struct EnquiryReceiptDTO: Decodable, Sendable {
    let status: String
}
