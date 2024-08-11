//
//  NewsArticleListViewModel.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Foundation
import SwiftData

@MainActor
final class NewsArticleListViewModel: ObservableObject {
    private let newsUseCase: NewsUseCase

    @Published var articles = [Article]()

    @Published private(set) var isLoading = false
    @Published private(set) var emptyState: EmptyStateType?

    init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }

    /// Returns the already fetched articles if there's any otherwise, makes a call to the backend and returns the data.
    func getAllNewsArticles(storedArticles: [NewsArticle]) async {
        isLoading = true

        await handleNetworkRequest(storedArticles: storedArticles) {
            try await newsUseCase.getAllNewsArticles()
        }

        isLoading = false
    }

    /// Refreshes all the articles from the backend.
    func refreshArticles(storedArticles: [NewsArticle]) async {
        await handleNetworkRequest(storedArticles: storedArticles) {
            try await newsUseCase.getAllNewsArticles(forceRefresh: true)
        }
    }

    /// Saves the data to the device storage.
    func saveArticlesToStorage(context: ModelContext, storedArticles: [NewsArticle]) async {
        let storage = BackgroundStorage(modelContainer: context.container)
        await storage.save(newArticles: articles, storedArticles: storedArticles)
    }

    /// Handles the network request by making the request, updating the articles, and setting error state if needed.
    private func handleNetworkRequest(storedArticles: [NewsArticle], request: () async throws -> [Article]) async {
        do {
            let articles = try await request()

            if articles.isEmpty {
                emptyState = .noData
            } else {
                self.articles = articles
                emptyState = nil
            }
        } catch {
            handleNetworkError(with: storedArticles, error: error)
        }
    }

    /// Handles the network error. If there are stored data then stored data is shown otherwise, shows error state
    private func handleNetworkError(with storedArticles: [NewsArticle], error: Error) {
        if storedArticles.isEmpty {
            self.emptyState = .networkError(message: error.localizedDescription)
        } else if articles.isEmpty {
            articles = storedArticles.map(\.article)
        }
    }
}

extension NewsArticle {
    /// Maps `NewsArticle` article to `Article` object.
    var article: Article {
        .init(
            source: .init(
                id: source.id,
                name: source.name
            ),
            author: author,
            title: title,
            description: descriptions,
            url: url?.absoluteString ?? "",
            urlToImage: urlToImage?.absoluteString,
            imageData: imageData,
            publishedAt: publishedAt,
            content: content
        )
    }
}
