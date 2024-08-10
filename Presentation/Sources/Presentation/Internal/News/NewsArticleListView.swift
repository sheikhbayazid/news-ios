//
//  NewsArticleListView.swift
//
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import SwiftUI

struct NewsArticleListView: View {
    init(newsUseCase: NewsUseCase) {
    }

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    NewsArticleListView(newsUseCase: PreviewNewsUseCase())
}
