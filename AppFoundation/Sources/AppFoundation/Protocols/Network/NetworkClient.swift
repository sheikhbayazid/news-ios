//
//  NetworkClient.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

public protocol NetworkClient {
    /// Makes a GET request to the backend and returns response data with provided type or throws an error.
    /// - Parameters:
    ///   - path: API path to make request
    ///   - type: Type of data that is expected to decode from the GET request
    /// - Returns: Decoded data from the GET response or an error
    func get<Data: Decodable>(path: String, type: Data.Type) async throws -> Data

    /// Makes a POST request to the backend without any payload and returns response data with provided type or throws an error.
    /// - Parameters:
    ///   - path: API path to make request
    ///   - type: Type of data that is expected to decode from the POST request
    /// - Returns: Decoded data from the POST response or an error
    func post<Data: Decodable>(path: String, type: Data.Type) async throws -> Data
}
