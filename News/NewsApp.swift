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
        let schema = Schema([NewsArticle.self])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        let apiBaseURL = "https://newsapi.org"
        let apiVersion = "v2"

        #warning("Replace the placeholder with your API Key.")
        var apiKey = "YOUR_API_KEY"

        let apiKeyConfigValue: String? = try? Configuration.value(for: "API_KEY")
        if let apiKeyConfigValue, !apiKeyConfigValue.isEmpty {
            apiKey = apiKeyConfigValue
        }

        let networkClient = RestAPINetworkClient(
            endpoint: .init(
                baseURL: apiBaseURL,
                version: apiVersion,
                apiKey: apiKey
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
