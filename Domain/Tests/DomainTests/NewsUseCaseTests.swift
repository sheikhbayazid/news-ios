//
//  NewsUseCaseTests.swift
//  Domain
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import SwiftData
import XCTest

@testable import Domain

final class NewsUseCaseTests: XCTestCase {
    private var context: ModelContext?

    private var networkClient: MockedNetworkClient!
    private var sut: DefaultNewsUseCase!

    override func setUp() {
        // To use SwiftData model NewsArticle, it needs to set the context in the memory,
        // otherwise it crashes when running tests
        let schema = Schema([NewsArticle.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        guard let container = try? ModelContainer(for: schema, configurations: [config]) else {
            XCTFail("Failed to set up model container")
            return
        }
        context = ModelContext(container)

        networkClient = .init()
        sut = DefaultNewsUseCase(networkClient: networkClient)
    }

    override func tearDown() {
        context = nil

        sut = nil
        networkClient = nil
    }

    func testInitialFetchAndCachePopulation() async throws {
        let expectedArticles = [
            makeNewsArticle(title: "Article 1"),
            makeNewsArticle(title: "Article 2")
        ]
        let networkResponse = NewsNetworkResponse(
            status: "OK",
            totalResults: expectedArticles.count,
            articles: expectedArticles.map(\.networkResponseArticle)
        )
        networkClient.data = makeJSONData(networkResponse)

        let articles = try await sut.getAllNewsArticles()

        XCTAssertEqual(articles.count, expectedArticles.count)
        XCTAssertEqual(articles.first?.title, expectedArticles.first?.title)
        XCTAssertEqual(articles.last?.title, expectedArticles.last?.title)

        XCTAssertEqual(sut.cache.count, expectedArticles.count)
        XCTAssertEqual(sut.cache.first?.title, expectedArticles.first?.title)
        XCTAssertEqual(sut.cache.last?.title, expectedArticles.last?.title)
    }

    func testCacheRetrieval() async throws {
        let expectedArticles = [
            makeNewsArticle(title: "Article 1"),
            makeNewsArticle(title: "Article 2")
        ]
        let networkResponse = NewsNetworkResponse(
            status: "OK",
            totalResults: expectedArticles.count,
            articles: expectedArticles.map(\.networkResponseArticle)
        )
        networkClient.data = makeJSONData(networkResponse)

        // First call to populate cache
        _ = try await sut.getAllNewsArticles()

        XCTAssertEqual(sut.cache.count, expectedArticles.count)

        // Set mock data to nil to ensure network is not called again
        networkClient.data = nil

        // Second call to retrieve from cache
        let articles = try await sut.getAllNewsArticles()

        XCTAssertEqual(articles.count, expectedArticles.count)
        XCTAssertEqual(articles.first?.title, expectedArticles.first?.title)
        XCTAssertEqual(articles.last?.title, expectedArticles.last?.title)
    }

    func testForceRefresh() async throws {
        let initialArticles = [
            makeNewsArticle(title: "Initial Article")
        ]
        let initialResponse = NewsNetworkResponse(
            status: "OK",
            totalResults: initialArticles.count,
            articles: initialArticles.map(\.networkResponseArticle)
        )
        networkClient.data = makeJSONData(initialResponse)

        // First call to populate cache
        _ = try await sut.getAllNewsArticles()

        let refreshedArticles = [
            makeNewsArticle(title: "Refreshed Article")
        ]
        let refreshedResponse = NewsNetworkResponse(
            status: "OK",
            totalResults: refreshedArticles.count,
            articles: refreshedArticles.map(\.networkResponseArticle)
        )
        networkClient.data = makeJSONData(refreshedResponse)

        // Second call with force refresh
        let articles = try await sut.getAllNewsArticles(forceRefresh: true)

        XCTAssertEqual(articles.count, refreshedArticles.count)
        XCTAssertEqual(articles.first?.title, refreshedArticles.first?.title)
        XCTAssertEqual(articles.last?.title, refreshedArticles.last?.title)

        XCTAssertEqual(sut.cache.count, refreshedArticles.count)
        XCTAssertEqual(sut.cache.first?.title, refreshedArticles.first?.title)
        XCTAssertEqual(sut.cache.last?.title, refreshedArticles.last?.title)
    }

    func testCacheInvalidatingOnForceRefresh() async throws {
         let initialArticles = [
             makeNewsArticle(title: "Initial Article")
         ]
         let initialResponse = NewsNetworkResponse(
             status: "OK",
             totalResults: initialArticles.count,
             articles: initialArticles.map(\.networkResponseArticle)
         )
         networkClient.data = makeJSONData(initialResponse)

         // First call to populate cache
         _ = try await sut.getAllNewsArticles()

         let refreshedArticles = [
             makeNewsArticle(title: "Refreshed Article")
         ]
         let refreshedResponse = NewsNetworkResponse(
             status: "OK",
             totalResults: refreshedArticles.count,
             articles: refreshedArticles.map(\.networkResponseArticle)
         )
         networkClient.data = makeJSONData(refreshedResponse)

         // Second call with force refresh to update cache
         _ = try await sut.getAllNewsArticles(forceRefresh: true)

         // Set mock data to nil to ensure network is not called again
         networkClient.data = nil

         // Third call to retrieve from updated cache
         let articles = try await sut.getAllNewsArticles()

         XCTAssertEqual(articles.count, refreshedArticles.count)
         XCTAssertEqual(articles.first?.title, refreshedArticles.first?.title)
         XCTAssertEqual(articles.last?.title, refreshedArticles.last?.title)
     }

    private func makeJSONData<T: Encodable>(_ data: T) -> Data? {
        try? JSONEncoder().encode(data)
    }

    private func makeNewsArticle(title: String) -> NewsArticle {
        NewsArticle(
            source: .init(id: nil, name: ""),
            author: "",
            title: title,
            description: "",
            urlString: "",
            urlToImage: nil,
            publishedAt: nil,
            content: ""
        )
    }
}

private extension NewsArticle {
    var networkResponseArticle: NewsNetworkResponse.Article {
        .init(
            source: .init(
                id: source.id,
                name: source.name
            ),
            author: author,
            title: title,
            description: descriptions,
            url: url?.absoluteString ?? "",
            urlToImage: urlToImage?.absoluteString,
            publishedAt: publishedAt,
            content: content
        )
    }
}
