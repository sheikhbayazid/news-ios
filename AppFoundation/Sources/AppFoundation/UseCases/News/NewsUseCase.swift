//
//  NewsUseCase.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import Foundation

public protocol NewsUseCase {
    /// Gets all the news articles or throws an error.
    func getAllNewsArticles() async throws -> [NewsArticle]
}
