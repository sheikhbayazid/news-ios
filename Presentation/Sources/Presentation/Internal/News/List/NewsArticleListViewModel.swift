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
    private var context: ModelContext?

    @Published var articles = [Article]()

    @Published private(set) var isLoading = false
    @Published private(set) var emptyState: EmptyStateType?

    init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }

    func handleOnAppear(context: ModelContext, storedArticles: [NewsArticle]) async {
        self.context = context

        await getAllNewsArticles(storedArticles: storedArticles)
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

    /// Fetches the all the articles. Fetches the articles from the backend if there is no data available otherwise returns the fetched data.
    private func getAllNewsArticles(storedArticles: [NewsArticle]) async {
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

    /// Saves the data to the device storage.
    func saveArticlesToStorage(context: ModelContext) async {
        let storage = BackgroundStorage(modelContainer: context.container)
        await storage.save(articles: articles)
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
