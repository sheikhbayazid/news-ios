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
    private let removedArticleID = "[Removed]"

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    /// Gets all the news articles or throws an error.
    public func getAllNewsArticles() async throws -> [NewsArticle] {
        let response = try await networkClient.get(
            path: "everything?q=apple",
            type: NewsNetworkResponse.self
        )
        let newsArticles = response.articles.map(\.newsArticle)

        // Filtering the articles to not include removed articles.
        return newsArticles.filter {
            $0.title != removedArticleID
        }
    }
}
