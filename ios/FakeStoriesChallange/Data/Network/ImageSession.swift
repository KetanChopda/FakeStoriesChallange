//
//  ImageSession.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Builds the session product images load through, with explicit cache sizes.
enum ImageSession {
    static func make() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(
            memoryCapacity: NetworkConfig.ImageCache.memoryCapacity,
            diskCapacity: NetworkConfig.ImageCache.diskCapacity
        )
        return URLSession(configuration: configuration)
    }
}
