//
//  EnquiryViewModel.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Observation

/// Collects contact details, validates them through the use case, and reports the outcome.
@MainActor
@Observable
final class EnquiryViewModel {
    enum Status: Equatable {
        case editing
        case sending
        case sent
        case invalid(EnquiryValidationError)
        case failed(CatalogueError)
    }

    let productID: Int
    var name = ""
    var email = ""
    var phone = ""
    var message = ""
    private(set) var status: Status = .editing

    private let submitEnquiry: SubmitEnquiry

    init(productID: Int, submitEnquiry: SubmitEnquiry) {
        self.productID = productID
        self.submitEnquiry = submitEnquiry
    }

    func submit() async {
        status = .sending
        let enquiry = Enquiry(
            productID: productID,
            contact: ContactDetails(name: name, email: email, phone: phone.isEmpty ? nil : phone),
            message: message
        )
        do {
            try await submitEnquiry.execute(enquiry)
            status = .sent
        } catch let error as EnquiryValidationError {
            status = .invalid(error)
        } catch {
            status = .failed(.from(error))
        }
    }
}
