//
//  URLRequest+CodableTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

private struct UnitTestDemoData: Codable {
    let id: String
}

class FakeUrlSession: UrlSessionDataProvider {
    static let url = URL(string: "http://node-traversal.io")!
    let data: Data
    let statusCode: Int
    
    init(_ data: Data, statusCode: Int = 200) {
        self.data = data
        self.statusCode = statusCode
    }
        
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(url: FakeUrlSession.url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        
        return (data, response)
    }
}

final class URLRequest_CodableTests: XCTestCase {
    func testData() async throws {
        let demo = UnitTestDemoData(id: "ABC")
        let data = try JSONEncoder().encode(demo)
        let session = FakeUrlSession(data)
        
        let request = URLRequest(url: FakeUrlSession.url)
        let result = try await request.data(UnitTestDemoData.self, urlSession: session)
        
        XCTAssertEqual(result.id, "ABC")
    }
    
    func testError() async throws {
        let demo = UnitTestDemoData(id: "ABC")
        let data = try JSONEncoder().encode(demo)
        let session = FakeUrlSession(data, statusCode: 500)
        
        let request = URLRequest(url: FakeUrlSession.url)
        
        do {
             _ = try await request.data(UnitTestDemoData.self, urlSession: session)
             XCTFail("expected to throw an error.")
         } catch let error as HttpError {
             XCTAssertEqual(error.statusCode, 500)
         }
    }
}
