//
//  NewsArticleListViewModel.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Foundation
import SwiftData

final class NewsArticleListViewModel: ObservableObject {
    private let newsUseCase: NewsUseCase

    @Published private(set) var articles = [NewsArticle]()

    @Published private(set) var isLoading = false
    @Published private(set) var emptyState: EmptyStateType?

    init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }

    func getAllNewsArticles(context: ModelContext, storedArticles: [NewsArticle]) {
        isLoading = true

        Task { @MainActor in
            do {
                let articles = try await newsUseCase.getAllNewsArticles()

                if articles.isEmpty {
                    emptyState = .noData
                } else {
                    self.articles = articles
                    self.emptyState = nil

                    saveArticlesToStorage(context: context, articles: articles)
                }
            } catch {
                handleNetworkError(with: storedArticles, error: error)
            }

            isLoading = false
        }
    }

    func refreshArticles(context: ModelContext, storedArticles: [NewsArticle]) async {
        do {
            let articles = try await newsUseCase.getAllNewsArticles(forceRefresh: true)

            DispatchQueue.main.async {
                if articles.isEmpty {
                    self.emptyState = .noData
                } else {
                    self.articles = articles
                    self.emptyState = nil

                    self.saveArticlesToStorage(context: context, articles: articles)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.handleNetworkError(with: storedArticles, error: error)
            }
        }
    }

    /// Handles the network error. If there are stored data then stored data is shown otherwise, shows error state
    private func handleNetworkError(with storedArticles: [NewsArticle], error: Error) {
        if storedArticles.isEmpty {
            self.emptyState = .networkError(message: error.localizedDescription)
        } else if articles.isEmpty {
            articles = storedArticles
        }
    }

    /// Saves the data to the device storage.
    private func saveArticlesToStorage(context: ModelContext, articles: [NewsArticle]) {
        do {
            // Remove existing stored data
            try context.delete(model: NewsArticle.self)

            // Save new data
            articles.forEach {
                context.insert($0)
            }
        } catch {
            debugPrint(error)
        }
    }
}

// Removes warning for the sendable conformance.
extension ModelContext: @unchecked Sendable { }
