//
//  ImageSessionTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@Suite struct ImageSessionTests {

    @Test func `Image session caches with the configured memory and disk sizes`() {
        let cache = ImageSession.make().configuration.urlCache

        #expect(cache?.memoryCapacity == NetworkConfig.ImageCache.memoryCapacity)
        #expect(cache?.diskCapacity == NetworkConfig.ImageCache.diskCapacity)
    }
}
