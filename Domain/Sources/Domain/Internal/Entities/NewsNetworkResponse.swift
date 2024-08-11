//  swiftlint:disable nesting
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

extension Article {
    /// Maps news response article data to news article object.
    var newsArticle: NewsArticle {
        .init(
            source: .init(
                id: source.id,
                name: source.name
            ),
            author: author,
            title: title,
            description: description,
            urlString: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content
        )
    }
}
