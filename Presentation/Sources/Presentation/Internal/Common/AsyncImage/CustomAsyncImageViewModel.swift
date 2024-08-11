//
//  CustomAsyncImageViewModel.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-11.
//

import SwiftUI

@MainActor
final class CustomAsyncImageViewModel: ObservableObject {
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private static let cache = ImageCache()

    private let url: URL
    private let onDownloadFinish: (Data) -> Void

    init(
        url: URL,
        onDownloadFinish: @escaping (Data) -> Void
    ) {
        self.url = url
        self.onDownloadFinish = onDownloadFinish
    }

    func downloadImage() async {
        isLoading = true
        error = nil

        // Check if the image is already cached
        if let cachedImage = Self.cache.image(forKey: url) {
            self.image = cachedImage
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                // Cache the downloaded image
                Self.cache.setImage(downloadedImage, forKey: url)
                self.onDownloadFinish(data)

                withAnimation(.snappy) {
                    self.image = downloadedImage
                }
            }
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
