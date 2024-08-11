//
//  Article.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-11.
//

import Foundation

/// News article model that is used to fetch the data from the backend.
public struct Article: Codable, Equatable {
    public let source: Source
    public let author: String?

    public let title: String
    public let description: String

    public let url: String
    public let urlToImage: String?
    public var imageData: Data?

    public let publishedAt: Date?
    public let content: String

    public init(
        source: Source,
        author: String?,
        title: String,
        description: String,
        url: String,
        urlToImage: String?,
        imageData: Data?,
        publishedAt: Date?,
        content: String
    ) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.imageData = imageData
        self.publishedAt = publishedAt
        self.content = content
    }

    public struct Source: Codable, Equatable {
        public let id: String?
        public let name: String

        public init(
            id: String?,
            name: String
        ) {
            self.id = id
            self.name = name
        }
    }
}
