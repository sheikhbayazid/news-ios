//
//  NewsArticleListView.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import SwiftData
import SwiftUI

struct NewsArticleListView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \NewsArticle.publishedAt, order: .reverse)
    private var storedArticles: [NewsArticle]

    @StateObject private var viewModel: NewsArticleListViewModel

    init(newsUseCase: NewsUseCase) {
        _viewModel = .init(wrappedValue: .init(newsUseCase: newsUseCase))
    }

    var body: some View {
        List {
            container()
        }
        .task {
            await viewModel.handleOnAppear(
                context: modelContext,
                storedArticles: storedArticles
            )
        }
        .task(id: viewModel.articles, priority: .background) {
            await viewModel.saveArticlesToStorage(
                context: modelContext,
                storedArticles: storedArticles
            )
        }
        .refreshable {
            await viewModel.refreshArticles(
                storedArticles: storedArticles
            )
        }
        .navigationTitle("News")
    }

    @ViewBuilder
    private func container() -> some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
        } else if let emptyState = viewModel.emptyState {
            EmptyStateView(type: emptyState)
        } else {
            content()
        }
    }

    @ViewBuilder
    private func content() -> some View {
        ForEach(viewModel.articles.indices, id: \.self) { index in
            let article = viewModel.articles[index]

            NavigationLink {
                ArticleDetailsView(article: article)
            } label: {
                ArticlePreviewView(article: article)
            }
        }
    }
}

#Preview {
    NavigationStack {
        NewsArticleListView(newsUseCase: PreviewNewsUseCase())
    }
    .modelContainer(for: NewsArticle.self, inMemory: true)
}
