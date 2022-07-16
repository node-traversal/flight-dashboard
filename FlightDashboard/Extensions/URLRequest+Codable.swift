//
//  URLRequest+Codable.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

struct HttpError: Error {
    let statusCode: Int?
}

protocol UrlRequestProvider {
    func request(method: HttpMethod, uri: String) throws -> URLRequest
    
    func request<T>(_ type: T.Type, method: HttpMethod, uri: String) async throws -> T where T: Decodable
}

protocol UrlSessionDataProvider {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: UrlSessionDataProvider {
}

extension URLRequest {
    func data<T>(_ type: T.Type, _ requiredStatus: Int = 200, urlSession: UrlSessionDataProvider = URLSession.shared) async throws -> T where T: Decodable {
        let url = self.url?.absoluteString ?? "???"
        // AnalyticsFactory.startResourceLoading(url: url, request: self)
        
        let (data, response) = try await urlSession.data(for: self, delegate: nil)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        guard statusCode == requiredStatus else {
            print("Error while fetching data: \(url), status=\(statusCode ?? 0)")
            throw HttpError(statusCode: statusCode)
        }
        print("---------------------------------------")
        print("RESPONSE: \(url): ")
        print(data.prettyPrintJson)
        print("---------------------------------------")
        // AnalyticsFactory.stopResourceLoading(url: url, response: response)
        
        return try JSONDecoder().decode(type, from: data)
    }
}
