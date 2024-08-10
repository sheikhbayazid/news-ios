//
//  NewsArticleListView.swift
//
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import SwiftData
import SwiftUI

struct NewsArticleListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var storedArticles: [NewsArticle]

    @StateObject private var viewModel: NewsArticleListViewModel

    init(newsUseCase: NewsUseCase) {
        _viewModel = .init(wrappedValue: .init(newsUseCase: newsUseCase))
    }

    var body: some View {
        List {
            container()
        }
        .onAppear {
            viewModel.getAllNewsArticles(
                context: modelContext,
                storedArticles: storedArticles
            )
        }
        .refreshable {
            await viewModel.refreshArticles(
                context: modelContext,
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
        ForEach(0..<viewModel.articles.indices.count, id: \.self) { index in
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
