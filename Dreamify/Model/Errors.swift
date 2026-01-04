//
//  Errors.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/7/25.
//

enum APIError: Error {
    case invalidURL
    case networkError
    case noData
    case decodingError
    case authenticationError
    case serverError(Int, String) // statusCode, errorMessage
    case rateLimitExceeded(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError:
            return "Network error occurred"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .authenticationError:
            return "Authentication required"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
            
        case .rateLimitExceeded(let message):
            return message
        }
    }
}
struct ErrorResponse: Codable {
    let error: String
}
