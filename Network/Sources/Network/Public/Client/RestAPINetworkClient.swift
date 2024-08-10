//
//  RestAPINetworkClient.swift
//  Network
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Foundation

public final class RestAPINetworkClient: NetworkClient {
    private lazy var decoder = getJSONDecoder()

    private let session: URLSessionProtocol
    private let endpoint: RestAPIEndpoint

    /// For testing purpose only.
    init(
        endpoint: RestAPIEndpoint,
        session: URLSessionProtocol
    ) {
        self.endpoint = endpoint
        self.session = session
    }

    public convenience init(endpoint: RestAPIEndpoint) {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 60
        let session = URLSession(configuration: configuration)

        self.init(endpoint: endpoint, session: session)
    }

    /// Makes a GET request to the backend and returns response data with provided type or throws an error.
    /// - Parameters:
    ///   - path: API path to make request
    ///   - type: Type of data that is expected to decode from the GET request
    /// - Returns: Decoded data from the GET response or an error
    public func get<Data: Decodable>(path: String, type: Data.Type) async throws -> Data {
        let data = try await request(method: .get, path: path)
        return try decoder.decode(Data.self, from: data)
    }

    /// Makes a POST request to the backend without any payload and returns response data with provided type or throws an error.
    /// - Parameters:
    ///   - path: API path to make request
    ///   - type: Type of data that is expected to decode from the POST request
    /// - Returns: Decoded data from the POST response or an error
    public func post<Data: Decodable>(path: String, type: Data.Type) async throws -> Data {
        let data = try await request(method: .post(payload: nil), path: path)
        return try decoder.decode(Data.self, from: data)
    }

    /// Makes a request to the backend based on the provided HTTPMethod and returns response data with provided type or throws an error.
    /// - Parameters:
    ///   - method: HTTPMethod to make request for
    ///   - endpoint: Endpoint to make request to
    ///   - additionalHeaders: Additional headers to add to the request
    /// - Returns: Data from the request response or an error.
    private func request(method: HTTPMethod, path: String) async throws -> Data {
        let urlString = "\(endpoint.baseURL)/\(endpoint.version)/\(path)"

        guard let url = URL(string: urlString) else {
            throw URLError(.unsupportedURL)
        }

        var allHTTPHeaderFields = ["X-Api-Key": endpoint.apiKey]
        if let httpHeaderField = method.httpHeaderField {
            allHTTPHeaderFields.add(elements: httpHeaderField)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.method
        request.httpBody = method.httpBody
        request.allHTTPHeaderFields = allHTTPHeaderFields

        let (data, response) = try await session.dataCompatible(for: request)
        return try handleResponse(for: path, data: data, response: response, httpMethod: method)
    }

    /// Handle the response from the request. Returns the data only when the status code is 200 otherwise, throws an error.
    private func handleResponse(for path: String, data: Data, response: URLResponse, httpMethod: HTTPMethod) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkClientError.dataMissing
        }

        if httpResponse.statusCode == 200 {
            return data
        }

        let errorAsString = String(data: data, encoding: .utf8) ?? ""
        throw NetworkClientError.networkError(errorAsString)
    }

    /// JSON decoder that decodes the date in proper format.
    private func getJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .defaultDateDecodingStrategy
        return decoder
    }
}

private extension JSONDecoder.DateDecodingStrategy {
    /// Default Date decoding strategy that decodes the dates in ISO date format.
    static var defaultDateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            guard let date = dateString.iso8601 else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
            return date
        }
    }
}

private extension String {
    /// A formatted date from ISO 8601 string without fractional seconds.
    ///
    /// Example: "2023-07-26T22:00:00Z"
    var iso8601: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: self)
    }
}

private extension HTTPMethod {
    /// HTTP method name in raw String.
    var method: String {
        switch self {
        case .get:
            return "GET"

        case .post:
            return "POST"
        }
    }

    /// An optional HTTP header field for the HTTP method.
    var httpHeaderField: [String: String]? {
        switch self {
        case .get:
            return nil

        case .post:
            return ["Content-Type": "application/json"]
        }
    }

    /// An optional HTTP body data for the HTTP method.
    var httpBody: Data? {
        switch self {
        case .get:
            return nil

        case .post(let payload):
            if let payload {
                let encodedData = try? JSONEncoder().encode(payload)
                return encodedData
            }
            return nil
        }
    }
}

private extension Dictionary {
    /// Adds elements to the dictionary.
    mutating func add(elements: [Key: Value]) {
        merge(elements, uniquingKeysWith: { first, _ in first })
    }
}
