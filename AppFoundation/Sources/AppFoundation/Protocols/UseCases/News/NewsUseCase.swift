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
    /// If there is data presents, returns the data otherwise refreshes the data from the backend.
    func getAllNewsArticles() async throws -> [Article] {
        try await getAllNewsArticles(forceRefresh: false)
    }
}
