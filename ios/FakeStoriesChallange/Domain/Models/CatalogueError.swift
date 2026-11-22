//
//  CatalogueError.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Failures the app can explain to the user; repositories translate lower-level errors into these.
enum CatalogueError: Error, Equatable, Sendable {
    case offline
    case server
    case unknown

    /// Keeps errors already in Domain terms; anything else is unknown.
    static func from(_ error: any Error) -> CatalogueError {
        error as? CatalogueError ?? .unknown
    }
}
