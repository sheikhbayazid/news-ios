//
//  ArticleImageView.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-11.
//

import AppFoundation
import SwiftUI

struct ArticleImageView: View {
    let article: Article

    var body: some View {
        if let imageData = article.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else if let urlToImageString = article.urlToImage, let urlToImage = URL(string: urlToImageString) {
            CustomAsyncImage(url: urlToImage)
        } // Image URL is optional so doesn't need to handle `else`
    }
}

#Preview {
    ArticleImageView(article: .preview1)
}
