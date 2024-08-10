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
struct NewsNetworkResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]

    struct Article: Decodable {
        let source: Source
        let author: String?

        let title: String
        let description: String

        let url: String
        let urlToImage: String?

        let publishedAt: Date?
        public let content: String

        struct Source: Decodable {
            let id: String?
            let name: String
        }
    }
}

extension NewsNetworkResponse.Article {
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
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content
        )
    }
}
