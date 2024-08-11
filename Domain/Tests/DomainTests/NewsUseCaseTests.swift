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
    private var networkClient: MockedNetworkClient!
    private var sut: DefaultNewsUseCase!

    override func setUp() {
        networkClient = .init()
        sut = .init(networkClient: networkClient)
    }

    override func tearDown() {
        sut = nil
        networkClient = nil
    }

    func testInitialFetchAndCachePopulation() async throws {
        let expectedArticles = [
            makeArticle(title: "Article 1"),
            makeArticle(title: "Article 2")
        ]
        let networkResponse = NewsNetworkResponse(
            status: "OK",
            totalResults: expectedArticles.count,
            articles: expectedArticles
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
            makeArticle(title: "Article 1"),
            makeArticle(title: "Article 2")
        ]
        let networkResponse = NewsNetworkResponse(
            status: "OK",
            totalResults: expectedArticles.count,
            articles: expectedArticles
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
            makeArticle(title: "Initial Article")
        ]
        let initialResponse = NewsNetworkResponse(
            status: "OK",
            totalResults: initialArticles.count,
            articles: initialArticles
        )
        networkClient.data = makeJSONData(initialResponse)

        // First call to populate cache
        _ = try await sut.getAllNewsArticles()

        let refreshedArticles = [
            makeArticle(title: "Refreshed Article")
        ]
        let refreshedResponse = NewsNetworkResponse(
            status: "OK",
            totalResults: refreshedArticles.count,
            articles: refreshedArticles
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
             makeArticle(title: "Initial Article")
         ]
         let initialResponse = NewsNetworkResponse(
             status: "OK",
             totalResults: initialArticles.count,
             articles: initialArticles
         )
         networkClient.data = makeJSONData(initialResponse)

         // First call to populate cache
         _ = try await sut.getAllNewsArticles()

         let refreshedArticles = [
             makeArticle(title: "Refreshed Article")
         ]
         let refreshedResponse = NewsNetworkResponse(
             status: "OK",
             totalResults: refreshedArticles.count,
             articles: refreshedArticles
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

    private func makeArticle(title: String) -> Article {
        Article(
            source: .init(id: nil, name: ""),
            author: "",
            title: title,
            description: "",
            url: "",
            urlToImage: nil,
            imageData: nil,
            publishedAt: nil,
            content: ""
        )
    }
}
