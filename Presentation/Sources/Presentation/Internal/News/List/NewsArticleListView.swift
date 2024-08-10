//
//  NewsArticleListView.swift
//
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import SwiftUI

struct NewsArticleListView: View {
    @StateObject private var viewModel: NewsArticleListViewModel

    init(newsUseCase: NewsUseCase) {
        _viewModel = .init(wrappedValue: .init(newsUseCase: newsUseCase))
    }

    var body: some View {
        List {
            container()
        }
        .onAppear {
            viewModel.getAllNewsArticles()
        }
        .refreshable {
            await viewModel.refreshArticles()
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
                Text(markdown: article.content)
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
}
