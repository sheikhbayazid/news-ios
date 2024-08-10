//
//  MockedURLSession.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

import Foundation
@testable import Network

/// A mock URL session for testing purposes.
///
/// This class conforms to `URLSessionProtocol` and allows the injection of predefined responses,
/// data, and errors to simulate network conditions during testing.
final class MockedURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    var delay: TimeInterval?

    /// Performs a data task for a given URL request, simulating a URL session.
    ///
    /// - Parameter request: A URL request object that provides the URL, cache policy, request type, body data or body stream, and so on.
    /// - Returns: A tuple containing the data and response.
    ///
    /// This method helps with testing by allowing the simulation of different network responses and errors.
    func dataCompatible(for request: URLRequest) async throws -> (Data, URLResponse) {
        let delay = getTimeoutDelay()

        // Simulate network delay if necessary
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        // Simulate an error if provided
        if let error = error {
            throw error
        }

        // Simulate a successful response with data
        if let data = data, let response = response {
            return (data, response)
        }

        // If neither data nor error is provided, throw a generic error
        throw URLError(.unknown)
    }

    private func getTimeoutDelay() -> TimeInterval {
        let delay = self.delay ?? 0
        self.delay = nil // reset for the next call
        return delay
    }
}
