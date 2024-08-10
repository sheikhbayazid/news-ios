//
//  NewsUseCase.swift
//  Domain
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Foundation

public final class DefaultNewsUseCase: NewsUseCase {
    private let networkClient: NetworkClient

    private var cache = [NewsArticle]()
    private let removedArticleID = "[Removed]"

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    /// Gets all the news articles or throws an error.
    public func getAllNewsArticles(forceRefresh: Bool) async throws -> [NewsArticle] {
        if forceRefresh {
            return try await refreshAllNewsArticles()
        }

        if cache.isEmpty {
            return try await refreshAllNewsArticles()
        } else {
            return cache
        }
    }

    /// Makes a call to the backend and returns the data.
    private func refreshAllNewsArticles() async throws -> [NewsArticle] {
        let response = try await networkClient.get(
            path: "everything?q=apple",
            type: NewsNetworkResponse.self
        )
        let newsArticles = response.articles.map(\.newsArticle)

        // Filtering the articles to not include removed articles.
        let articles = newsArticles.filter {
            $0.title != removedArticleID
        }
        cache = articles
        return articles
    }
}
