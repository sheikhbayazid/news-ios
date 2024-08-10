//
//  NewsArticleListViewModel.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Foundation

final class NewsArticleListViewModel: ObservableObject {
    private let newsUseCase: NewsUseCase

    @Published private(set) var articles = [NewsArticle]()

    @Published private(set) var isLoading = false
    @Published private(set) var emptyState: EmptyStateType?

    init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }

    func getAllNewsArticles() {
        isLoading = true

        Task { @MainActor in
            do {
                let articles = try await newsUseCase.getAllNewsArticles()

                if !articles.isEmpty {
                    self.articles = articles
                    emptyState = nil
                } else {
                    emptyState = .noData
                }
            } catch {
                self.emptyState = .networkError
            }

            isLoading = false
        }
    }

    func refreshArticles() async {
        do {
            let articles = try await newsUseCase.getAllNewsArticles()

            DispatchQueue.main.async {
                if !articles.isEmpty {
                    self.articles = articles
                    self.emptyState = nil
                } else {
                    self.emptyState = .noData
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.emptyState = .networkError
            }
        }
    }
}
