//
//  NewsNetworkResponse.swift
//  Domain
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Foundation

/// Internal object for parsing the news network response.
struct NewsNetworkResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
