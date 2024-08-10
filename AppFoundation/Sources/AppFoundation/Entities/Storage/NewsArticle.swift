//
//  NewsArticle.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation
import SwiftData

@Model
public class NewsArticle {
    public let source: Source
    public let author: String?

    public let title: String
    public let descriptions: String

    public let url: URL?
    public let urlToImage: URL?

    public let publishedAt: Date?
    public let content: String

    public init(
        source: Source,
        author: String?,
        title: String,
        description: String,
        urlString: String,
        urlToImage: String?,
        publishedAt: Date?,
        content: String
    ) {
        self.source = source
        self.author = author
        self.title = title
        self.descriptions = description

        if let url = URL(string: urlString) {
            self.url = url
        }

        if let urlToImage {
            self.urlToImage = URL(string: urlToImage) ?? nil
        }

        self.publishedAt = publishedAt
        self.content = content
    }

    public struct Source: Codable {
        public let id: String?
        public let name: String

        public init(id: String?, name: String) {
            self.id = id
            self.name = name
        }
    }
}
