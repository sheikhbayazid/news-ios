//
//  NetworkClientError.swift
//  Network
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

enum NetworkClientError: Error, Equatable {
    case dataMissing
    case networkError(message: String)
}

extension NetworkClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataMissing:
            "Could not find any data, Please try again later."

        case .networkError(let message):
            message
        }
    }
}
