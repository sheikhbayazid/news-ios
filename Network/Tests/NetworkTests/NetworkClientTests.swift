//
//  NetworkClientTests.swift
//  AppFoundation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import XCTest

@testable import Network

final class NetworkClientTests: XCTestCase {
    private var session: MockedURLSession!
    private var sut: NetworkClient!

    override func setUp() {
        session = MockedURLSession()
        sut = RestAPINetworkClient(
            endpoint: .init(
                baseURL: "test",
                version: "v1",
                apiKey: ""
            ),
            session: session
        )
    }

    override func tearDown() {
        sut = nil
        session = nil
    }

    // MARK: GET

    func testGetRequestSuccess() async throws {
        let expectedData = ExampleData(data: "data1")

        session.data = makeJSONData(expectedData)
        session.response = makeHTTPResponse()

        let data = try await sut.get(path: "test", type: ExampleData.self)
        XCTAssertEqual(expectedData, data)
    }

    func testGetRequestFailed() async {
        let expectedData = ExampleData(data: "data1")

        session.data = makeJSONData(expectedData)
        session.response = makeHTTPResponse(with: 401)
        session.error = NetworkClientError.dataMissing

        do {
            let _ = try await sut.get(path: "test", type: ExampleData.self)
            XCTFail("Expected to throw, but it didn't.")
        } catch let error as NetworkClientError {
            XCTAssertEqual(error, .dataMissing)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: POST

    func testPostRequestSuccess() async throws {
        let expectedData = ExampleData(data: "data1")

        session.data = makeJSONData(expectedData)
        session.response = makeHTTPResponse()

        let data = try await sut.post(path: "test", type: ExampleData.self)
        XCTAssertEqual(expectedData, data)
    }

    func testPostRequestFailed() async {
        let expectedData = ExampleData(data: "data1")

        session.data = makeJSONData(expectedData)
        session.response = makeHTTPResponse(with: 401)
        session.error = NetworkClientError.dataMissing

        do {
            let _ = try await sut.post(path: "test", type: ExampleData.self)
            XCTFail("Expected to throw, but it didn't.")
        } catch let error as NetworkClientError {
            XCTAssertEqual(error, .dataMissing)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: Date Parsing

    func testDateParsingSuccessForGetRequest() async throws {
        let expectedData = ExampleDataWithDate.mock
        let jsonData = exampleJSONWithCorrectDate.data(using: .utf8)

        session.data = jsonData
        session.response = makeHTTPResponse()

        let data = try await sut.get(path: "test", type: ExampleDataWithDate.self)
        XCTAssertEqual(expectedData, data)
    }

    func testDateParsingFailedForGetRequest() async throws {
        let jsonData = exampleJSONWithWrongDate.data(using: .utf8)

        session.data = jsonData
        session.response = makeHTTPResponse()

        do {
            let _ = try await sut.post(path: "test", type: ExampleDataWithDate.self)
            XCTFail("Expected to throw, but it didn't.")
        } catch {
            if case .dataCorrupted = error as? DecodingError {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected to throw dataCorrupted error, but it didn't.")
            }
        }
    }
}

private extension NetworkClientTests {
    func makeJSONData<T: Encodable>(_ data: T) -> Data? {
        try? JSONEncoder().encode(data)
    }

    func makeHTTPResponse(with statusCode: Int = 200) -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "test")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }

    var exampleJSONWithCorrectDate: String {
"""
  {
    "title": "Date example",
    "date": "2024-08-09T00:00:00Z"
  }
"""
    }

    var exampleJSONWithWrongDate: String {
"""
  {
    "title": "Date example",
    "date": "2024-08-09"
  }
"""
    }
}

private struct ExampleData: Codable, Equatable {
    private let data: String

    init(data: String) {
        self.data = data
    }
}

struct ExampleDataWithDate: Codable, Equatable {
    let title: String
    let date: Date

    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }

    static var mock: Self {
        .init(title: "Date example", date: exampleDate)
    }

    private static var exampleDate: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 08
        dateComponents.day = 09

        // Using a fixed time zone so that it starts from 00:00
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        return calendar.date(from: dateComponents)!
    }
}

