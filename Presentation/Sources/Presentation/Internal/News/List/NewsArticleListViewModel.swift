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
    @Published private(set) var errorMessage: String?

    init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }

    func getAllNewsArticles() {
        Task { @MainActor in
            do {
                let articles = try await newsUseCase.getAllNewsArticles()
                self.articles = articles
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func refreshArticles() async {
        do {
            let articles = try await newsUseCase.getAllNewsArticles()

            DispatchQueue.main.async {
                self.articles = articles
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
