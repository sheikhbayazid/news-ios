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

    @Published private(set) var articles = [Article]()

    @Published private(set) var isLoading = false
    @Published private(set) var emptyState: EmptyStateType?

    init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }

    /// Fetches the all the articles. Fetches the articles from the backend if there is no data available otherwise returns the fetched data.
    func getAllNewsArticles(storedArticles: [NewsArticle]) async {
        isLoading = true

        do {
            let articles = try await newsUseCase.getAllNewsArticles()

            if articles.isEmpty {
                emptyState = .noData
            } else {
                self.articles = articles
                self.emptyState = nil
            }
        } catch {
            handleNetworkError(with: storedArticles, error: error)
        }

        isLoading = false
    }

    /// Refreshes all the articles from the backend.
    func refreshArticles(storedArticles: [NewsArticle]) async {
        do {
            let articles = try await newsUseCase.getAllNewsArticles(forceRefresh: true)

            if articles.isEmpty {
                self.emptyState = .noData
            } else {
                self.articles = articles
                self.emptyState = nil
            }
        } catch {
            self.handleNetworkError(with: storedArticles, error: error)
        }
    }

    /// Saves the data to the device storage.
    func saveArticlesToStorage(context: ModelContext, oldArticles: [Article], newArticles: [Article]) {
        guard !newArticles.isEmpty else {
            return
        }

        do {
            // Remove existing stored data
            try context.delete(model: NewsArticle.self)

            // Save new data
            let newsArticles = newArticles.map(\.newsArticle)
            newsArticles.forEach {
                context.insert($0)
            }
        } catch {
            debugPrint(error)
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

private extension NewsArticle {
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
