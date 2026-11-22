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
    case enquiries

    var method: HTTPMethod {
        switch self {
        case .products, .product:
            .get
        case .enquiries:
            .post
        }
    }

    func request(baseURL: URL) -> URLRequest {
        var url = baseURL
        for component in pathComponents {
            url = url.appending(path: component)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }

    private var pathComponents: [String] {
        switch self {
        case .products:
            [NetworkConfig.Path.products]
        case .product(let id):
            [NetworkConfig.Path.products, String(id)]
        case .enquiries:
            [NetworkConfig.Path.enquiries]
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
