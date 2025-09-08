//
//  Errors.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/7/25.
//

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError
    case authenticationError
    case serverError(Int)
}
