//
//  ArticleDetailsView.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import SwiftUI

struct ArticleDetailsView: View {
    let article: NewsArticle

    var body: some View {
        container()
            .navigationTitle(article.source.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolBarContent)
    }

    @ViewBuilder
    private func container() -> some View {
        ScrollView {
            VStack(spacing: 20) {
                image()
                content()
            }
            .padding(.vertical)
        }
    }

    @ViewBuilder
    private func image() -> some View {
        if let urlToImage = article.urlToImage {
            CustomAsyncImage(url: urlToImage)
        }
    }

    @ViewBuilder
    private func content() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            publisherInfo()
            textContent()
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func publisherInfo() -> some View {
        HStack {
            if let author = article.author {
                Text("By \(author)")
            }

            if let publishedAt = article.publishedAt {
                Spacer()
                Text(publishedAt, format: .dateTime)
            }
        }
        .fontWeight(.medium)
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func textContent() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(markdown: article.title)
                .font(.headline)

            Text(markdown: article.descriptions)
            Text(markdown: article.content)
        }
    }

    @ToolbarContentBuilder
    private func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            if let url = article.url {
                Link("Read more", destination: url)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color.blue)
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ArticleDetailsView(article: .preview1)
    }
}
