//
//  BackendEnquiryService.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Sends enquiries to the backend, which emails the sales inbox.
struct BackendEnquiryService: EnquiryService {
    let api: APIManager

    func submit(_ enquiry: Enquiry) async throws {
        do {
            let _: EnquiryReceiptDTO = try await api.post(.enquiries, body: EnquiryRequestDTO(enquiry))
        } catch let error as APIError {
            throw CatalogueError(error)
        }
    }
}
