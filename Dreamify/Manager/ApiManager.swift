//
//  ApiManager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//


import Foundation
import Foundation

// MARK: - Simple API Error
enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError
    case serverError(Int)
}

// MARK: - Simple API Client Manager
class APIClientManager {
    
    static let shared = APIClientManager()
    private let baseURL = "https://api.example.com"
    private var authToken: String?
    
    private init() {}
    
    // MARK: - Authentication
    func setToken(_ token: String) {
        self.authToken = token
    }
    
    func clearToken() {
        self.authToken = nil
    }
    
    // MARK: - GET Request
    func get<T: Codable>(endpoint: String, type: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        guard let result = try? JSONDecoder().decode(type, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    // MARK: - POST Request
    func post<T: Codable, U: Codable>(endpoint: String, body: U, type: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        guard let result = try? JSONDecoder().decode(type, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    // MARK: - PUT Request
    func put<T: Codable, U: Codable>(endpoint: String, body: U, type: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        guard let result = try? JSONDecoder().decode(type, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    // MARK: - DELETE Request
    func delete(endpoint: String) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 204 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
    }
}
