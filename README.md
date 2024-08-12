# News iOS

This iOS application is designed to display news articles fetched from [NewsAPI](https://newsapi.org/). The app is built using a **Modular Clean Architecture** with **MVVM**, **SwiftData** for local storage, and **SwiftLint** for code style enforcement.

## Project Structure

- **AppFoundation**: Shared entities, errors, and protocols.
- **Domain**: Business logic (e.g., fetching and caching news articles).
- **Presentation**: UI components and view logic using MVVM.
- **Network**: Handles HTTP requests and interactions with the backend.

## Features

- **List of Articles**: Displays a list of news articles fetched from the backend.
- **Article Details View**: Shows detailed information for each article, including the image, title, description, and content.
- **Image Downloading and Caching**: Images are downloaded and cached to minimize network requests, ensuring efficient use of bandwidth and quicker image loading times.
- **Efficient Data Fetching**: News articles are fetched once and cached. The app only refreshes data on user-initiated pull-to-refresh, reducing unnecessary network calls.
- **Offline Access**: Saves the fetched data to local storage using SwiftData, allowing users to view articles even when offline.

## Tests

- **Network Module**: Includes tests for the network client, ensuring reliable and correct interactions with the backend services.
- **Domain Module**: Includes tests for fetching and caching news articles, validating the business logic and ensuring data consistency and correctness.

## Storage

- **SwiftData**: Used for local storage.

## Code Style

- **SwiftLint**: Ensures consistent code style. Install via Homebrew:

  ```
  brew install swiftlint
  ```

## Getting Started

To get started with the News iOS app, follow these steps:

1. **Clone the Repository**: 
   ```
   git clone https://github.com/sheikhbayazid/news-ios.git
   ```

2. **Open in Xcode**: 
   ```
   open News.xcodeproj
   ```

3. **Add Your API Key**:
   - Open the `NewsApp.swift` file.
   - Replace the `YOUR_API_KEY` placeholder with your API key from [NewsAPI](https://newsapi.org/).

4. **Run the App**:
   - Build and run the app directly in Xcode.
