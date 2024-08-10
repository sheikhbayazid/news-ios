//
//  ArticlePreviewView.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import SwiftUI

struct ArticlePreviewView: View {
    var article: NewsArticle

    init(article: NewsArticle) {
        self.article = article
    }

    var body: some View {
        VStack(spacing: 8) {
            if let urlToImage = article.urlToImage, let imageURL = URL(string: urlToImage) {
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 12))
                    } else if phase.error != nil {
                        Image(systemName: "questionmark.diamond")
                            .imageScale(.large)
                    } else {
                        ProgressView()
                    }
                }
            }

            ArticleSummeryView(article: article)
        }
    }
}

private struct ArticleSummeryView: View {
    let article: NewsArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(article.title)
                .font(.headline)

            if let author = article.author {
                Text("By \(author)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            Text(markdown: article.descriptions)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}

#Preview {
    ArticlePreviewView(article: .preview1)
}
