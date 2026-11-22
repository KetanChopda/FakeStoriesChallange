//
//  APIEndpoint.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Every endpoint the app calls; the only place request paths are built.
enum APIEndpoint: Equatable, Sendable {
    case products
    case product(id: Int)

    func request(baseURL: URL) -> URLRequest {
        var url = baseURL
        for component in pathComponents {
            url = url.appending(path: component)
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }

    private var pathComponents: [String] {
        switch self {
        case .products:
            [NetworkConfig.Path.products]
        case .product(let id):
            [NetworkConfig.Path.products, String(id)]
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
}
