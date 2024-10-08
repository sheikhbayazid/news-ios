//
//  CustomAsyncImage.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import SwiftUI

struct CustomAsyncImage: View {
    @StateObject private var viewModel: CustomAsyncImageViewModel

    init(url: URL) {
        _viewModel = .init(wrappedValue: .init(url: url))
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let image = viewModel.image {
                imageView(image)
            } else if let error = viewModel.error {
                errorView(error)
            }
        }
        .task {
            await viewModel.downloadImage()
        }
    }

    @ViewBuilder
    private func imageView(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
    }

    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "photo")
                .font(.headline)

            Text(error.localizedDescription)
                .font(.caption)
                .foregroundStyle(.red)
        }
    }
}

// swiftlint: disable force_unwrapping
#Preview {
    CustomAsyncImage(
        url: URL(string: "https://media.wired.com/photos/66b3cac3a922a7712a7c43e0/191:100/w_1280,c_limit/Crash-Reports-Sec-140000036.jpg")!
    )
}
// swiftlint: enable force_unwrapping
