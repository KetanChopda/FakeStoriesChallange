//
//  NetworkTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing

/// Parent suite that serializes every network test, since they share one URLProtocol stub.
@Suite(.serialized) enum NetworkTests {}
