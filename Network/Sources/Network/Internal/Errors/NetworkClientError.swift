//
//  NetworkClientError.swift
//  Network
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

enum NetworkClientError: Error, Equatable {
    case dataMissing
    case networkError(String)
}
