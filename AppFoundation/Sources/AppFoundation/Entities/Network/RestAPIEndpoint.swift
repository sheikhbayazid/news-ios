//
//  RestAPIEndpoint.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

public struct RestAPIEndpoint {
    /// Base URL of the API endpoint
    public let baseURL: String

    /// Version of the API endpoint
    public let version: String

    /// API Key for the API endpoint
    public let apiKey: String

    public init(
        baseURL: String,
        version: String,
        apiKey: String
    ) {
        self.baseURL = baseURL
        self.version = version
        self.apiKey = apiKey
    }
}
