//
//  ErrorCopy.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Which symbol and message explain a failure to the user, so every screen says the same thing.
extension CatalogueError {
    var symbol: String {
        switch self {
        case .offline: Theme.Symbol.offline
        case .server: Theme.Symbol.server
        case .unknown: Theme.Symbol.failure
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .offline: Copy.offlineMessage
        case .server: Copy.serverMessage
        case .unknown: Copy.loadFailed
        }
    }

    var enquiryMessage: LocalizedStringResource {
        switch self {
        case .offline: Copy.enquiryOfflineMessage
        case .server: Copy.enquiryServerMessage
        case .unknown: Copy.sendFailed
        }
    }
}
