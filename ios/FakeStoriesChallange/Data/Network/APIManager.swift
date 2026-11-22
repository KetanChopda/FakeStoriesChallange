//
//  APIManager.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// The single gateway for network calls; runs off the main actor.
actor APIManager {
    private let session: URLSession
    private let baseURL: URL
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared, baseURL: URL = NetworkConfig.baseURL) {
        self.session = session
        self.baseURL = baseURL
    }

    func send<Response: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> Response {
        let (data, response) = try await perform(endpoint.request(baseURL: baseURL))
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard NetworkConfig.successStatusCodes.contains(httpResponse.statusCode) else {
            throw APIError.httpStatus(httpResponse.statusCode)
        }
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }

    private func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch let error as URLError where NetworkConfig.offlineErrorCodes.contains(error.code) {
            throw APIError.offline
        } catch {
            throw APIError.transport
        }
    }
}
