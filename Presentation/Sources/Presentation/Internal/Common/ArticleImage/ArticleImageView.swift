//
//  ArticleImageView.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-11.
//

import AppFoundation
import SwiftUI

struct ArticleImageView: View {
    @Binding var article: Article

    var body: some View {
        if let imageData = article.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else if let urlToImageString = article.urlToImage, let urlToImage = URL(string: urlToImageString) {
            CustomAsyncImage(
                url: urlToImage,
                onDownloadFinish: onDownloadFinish
            )
        }
    }

    private func onDownloadFinish(data: Data) {
        article.imageData = data
    }
}

#Preview {
    ArticleImageView(article: .constant(.preview1))
}
