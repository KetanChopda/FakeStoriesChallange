//
//  NetworkConfig.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Network constants live here so endpoints and the manager contain no literals.
enum NetworkConfig {
    static let baseURL = URL(string: "https://fakestoreapi.com")!
    static let successStatusCodes = 200..<300
    static let serverErrorStatusCodes = 500..<600

    /// URL errors that mean the device cannot reach the service right now.
    static let offlineErrorCodes: Set<URLError.Code> = [
        .notConnectedToInternet,
        .networkConnectionLost,
        .dataNotAllowed,
        .timedOut,
        .cannotFindHost,
        .cannotConnectToHost,
    ]

    enum Path {
        static let products = "products"
        static let enquiries = "enquiries"
    }

    enum Header {
        static let contentType = "Content-Type"
        static let jsonContentType = "application/json"
    }

    enum ImageCache {
        static let memoryCapacity = 64 * 1024 * 1024
        static let diskCapacity = 256 * 1024 * 1024
    }
}
