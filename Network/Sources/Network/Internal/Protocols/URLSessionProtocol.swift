//
//  URLSessionProtocol.swift
//  Network
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

/// A protocol to abstract URLSession for testing purposes.
protocol URLSessionProtocol {
    /// Performs a data task for a given URL request.
    ///
    /// - Parameter request: A URL request object that provides the URL, cache policy, request type, body data, and so on.
    /// - Returns: A tuple containing the data and response.
    ///
    /// This method helps with testing by allowing the use of a mock URLSession.
    func dataCompatible(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    /// Performs a data task for a given URL request.
    ///
    /// - Parameter request: A URL request object that provides the URL, cache policy, request type, body data, and so on.
    /// - Returns: A tuple containing the data and response.
    ///
    /// This method helps with testing by allowing the use of a mock URLSession.
    func dataCompatible(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
