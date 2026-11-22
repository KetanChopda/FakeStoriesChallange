//
//  APIError.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Failures the network layer reports; repositories translate these before they reach the app.
enum APIError: Error, Equatable {
    case offline
    case transport
    case invalidResponse
    case httpStatus(Int)
    case decoding
    case encoding
}
