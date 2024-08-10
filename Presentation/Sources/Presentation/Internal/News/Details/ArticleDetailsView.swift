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
        VStack(alignment: .leading, spacing: 8) {
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

            if let url = article.url {
                Link("Read more...", destination: url)
                    .foregroundStyle(.tint)
            }
        }
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
}

#Preview {
    NavigationStack {
        ArticleDetailsView(article: .preview1)
    }
}
