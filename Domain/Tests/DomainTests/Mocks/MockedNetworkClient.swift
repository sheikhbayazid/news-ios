//
//  MockedNetworkClient.swift
//  Domain
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Foundation

public final class MockedNetworkClient: NetworkClient {
    public var data: Data?
    public var error: Error?
    public var delay: TimeInterval = 0

    public func get<Data>(path: String, type: Data.Type) async throws -> Data where Data: Decodable {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        if let error {
            throw error
        }

        if let data {
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        }

        throw URLError(.badServerResponse)
    }

    public func post<Data>(path: String, type: Data.Type) async throws -> Data where Data: Decodable {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        if let error {
            throw error
        }

        if let data {
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        }

        throw URLError(.badServerResponse)
    }
}
