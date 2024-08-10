//
//  HTTPMethod.swift
//  Network
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

enum HTTPMethod {
    /// GET HTTP request method
    case get

    /// POST HTTP request method
    case post(payload: Encodable?)
}
