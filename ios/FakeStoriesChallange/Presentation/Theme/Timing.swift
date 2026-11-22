//
//  Timing.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Pauses that shape how the UI responds; kept here so they are tuned in one place.
enum Timing {
    /// How long typing must pause before a search runs; short enough to feel live, long enough to skip keystrokes.
    static let searchDebounce: Duration = .milliseconds(300)
}
