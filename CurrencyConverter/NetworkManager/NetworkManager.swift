//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 25/01/25.
//

import Foundation

final class NetworkManager {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(
        _ route: APIEndpoint,
        method: HttpMethod = .get
    ) async throws -> T {
        
        guard let url = route.endpoint else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let (data, response) = try await session.data(for: request)
        
        // Check for network errors or invalid HTTP status codes
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

// Enum to define HTTP methods
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

// Network error types
enum NetworkError: Error {
    case badURL
    case networkError(Error)
    case decodingError(Error)
    case unknown
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "The URL provided is invalid."
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        case .invalidResponse:
            return "Received an invalid response with status code"
        }
    }
}
