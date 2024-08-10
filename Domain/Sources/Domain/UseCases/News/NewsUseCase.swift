//
//  NewsUseCase.swift
//  Domain
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Foundation

public final class DefaultNewsUseCase: NewsUseCase {
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // TODO: Remove articles that are labeled with '[Remove]'
    /// Gets all the news articles or throws an error.
    public func getAllNewsArticles() async throws -> [NewsArticle] {
        let response = try await networkClient.get(path: "everything?q=apple", type: NewsNetworkResponse.self)
        return response.articles.map(\.newsArticle)
    }
}
