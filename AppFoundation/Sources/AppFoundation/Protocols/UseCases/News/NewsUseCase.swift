//
//  NewsUseCase.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

public protocol NewsUseCase {
    /// Gets all the news articles or throws an error.
    /// - Parameter forceRefresh: Whether it should refresh the data from the backend.
    func getAllNewsArticles(forceRefresh: Bool) async throws -> [Article]
}

public extension NewsUseCase {
    /// Gets all the news articles or throws an error.
    ///
    /// - Note: If the data is already fetched, returns the fetched data otherwise refreshes the data from the backend.
    func getAllNewsArticles() async throws -> [Article] {
        try await getAllNewsArticles(forceRefresh: false)
    }
}
