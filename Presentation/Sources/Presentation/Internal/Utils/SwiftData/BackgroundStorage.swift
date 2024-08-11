//
//  BackgroundStorage.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-11.
//

import AppFoundation
import SwiftData

@ModelActor
final actor BackgroundStorage {
    func save(articles: [Article]) {
        guard !articles.isEmpty else {
            // Not updating when the values are empty.
            return
        }

        do {
            // Remove existing stored data
            try modelContext.delete(model: NewsArticle.self)

            // Save new data
            let newsArticles = articles.map(\.newsArticle)
            newsArticles.forEach {
                modelContext.insert($0)
            }
            try modelContext.save()
        } catch {
            debugPrint(error)
        }
    }
}

private extension Article {
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
