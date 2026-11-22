//
//  CatalogueErrorMapping.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Maps network failures to the errors the app shows; server and decoding problems read the same to the user.
extension CatalogueError {
    init(_ error: APIError) {
        switch error {
        case .offline:
            self = .offline
        case .httpStatus(let status) where NetworkConfig.serverErrorStatusCodes.contains(status):
            self = .server
        case .invalidResponse, .decoding:
            self = .server
        case .httpStatus, .transport, .encoding:
            self = .unknown
        }
    }
}
