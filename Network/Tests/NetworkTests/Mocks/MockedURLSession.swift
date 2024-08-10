//
//  MockedURLSession.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation
@testable import Network

final class MockedURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    var delay: TimeInterval?

    func dataCompatible(for request: URLRequest) async throws -> (Data, URLResponse) {
        let delay = getTimeoutDelay()

        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        if let error = error {
            throw error
        }

        if let data = data, let response = response {
            return (data, response)
        }

        throw URLError(.unknown)
    }

    private func getTimeoutDelay() -> TimeInterval {
        let delay = self.delay ?? 0
        self.delay = nil // reset for the next call
        return delay
    }
}
