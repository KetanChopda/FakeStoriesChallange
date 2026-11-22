//
//  Theme.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import CoreGraphics

/// Layout and format values; screens read these instead of literals.
enum Theme {
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }

    enum Grid {
        static let minimumTileWidth: CGFloat = 160
        static let imageHeight: CGFloat = 180
        static let detailImageHeight: CGFloat = 320
    }

    enum Symbol {
        static let empty = "tray"
        static let failure = "exclamationmark.triangle"
        static let offline = "wifi.slash"
        static let server = "server.rack"
        static let success = "checkmark.circle"
        static let search = "magnifyingglass"
    }

    enum Form {
        static let messageLines = 3
    }

    enum Currency {
        static let code = "USD"
    }
}
