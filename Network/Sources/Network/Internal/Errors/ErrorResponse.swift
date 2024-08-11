//
//  ErrorResponse.swift
//  Network
//
//  Created by Sheikh Bayazid on 2024-08-11.
//

import Foundation

struct ErrorResponse: Decodable {
    let status: String
    let code: String
    let message: String
}
