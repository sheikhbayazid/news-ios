//
//  NewsApp.swift
//  News
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import Domain
import Network
import Presentation
import SwiftData
import SwiftUI

@main
struct NewsApp: App {
    private let newsUseCase: NewsUseCase

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            NewsArticle.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        let apiKey: String? = try? Configuration.value(for: "API_KEY")
        let networkClient = RestAPINetworkClient(
            endpoint: .init(
                baseURL: "https://newsapi.org",
                version: "v2",
                apiKey: apiKey ?? "YOUR_API_KEY"
            )
        )
        newsUseCase = DefaultNewsUseCase(networkClient: networkClient)
    }

    var body: some Scene {
        WindowGroup {
            RootView(newsUseCase: newsUseCase)
        }
        .modelContainer(sharedModelContainer)
    }
}
