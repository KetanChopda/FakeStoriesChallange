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
    private let encoder = JSONEncoder()

    init(session: URLSession = .shared, baseURL: URL = NetworkConfig.baseURL) {
        self.session = session
        self.baseURL = baseURL
    }

    func send<Response: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> Response {
        try await execute(endpoint.request(baseURL: baseURL))
    }

    /// Sends a JSON body to an endpoint and decodes the reply.
    func post<Body: Encodable & Sendable, Response: Decodable & Sendable>(_ endpoint: APIEndpoint, body: Body) async throws -> Response {
        var request = endpoint.request(baseURL: baseURL)
        request.setValue(NetworkConfig.Header.jsonContentType, forHTTPHeaderField: NetworkConfig.Header.contentType)
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw APIError.encoding
        }
        return try await execute(request)
    }

    private func execute<Response: Decodable & Sendable>(_ request: URLRequest) async throws -> Response {
        let (data, response) = try await perform(request)
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
