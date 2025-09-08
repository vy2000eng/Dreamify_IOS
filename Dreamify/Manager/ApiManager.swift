//
//  ApiManager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//


import Foundation
import Foundation



// MARK: - Simple API Client Manager
class APIClientManager {
    
    static let shared = APIClientManager()
    private let baseURL = "https://api.dream-if-y.us/api"
    private var authToken: String?
    
    private init() {}
    
    // MARK: - Authentication
    func setToken(_ token: String) {
        self.authToken = token
    }
    
    func clearToken() {
        self.authToken = nil
    }
    // MARK: - Completion Handler Version
    func request<T: Codable>(endpoint: String, method: String, body: [String: Any]? = nil, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(.networkError))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkError))
                return
            }
            
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let result = try? JSONDecoder().decode(type, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(result))
        }.resume()
    }
    
    // MARK: - Completion Handler Version
    func authRequest<T: Codable>(endpoint: String, method: String, body: [String: Any]? = nil, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let token = TokenManager.shared.getAccessToken() else {
            completion(.failure(.authenticationError)) // You'll need to add this to your APIError enum
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(.networkError))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkError))
                return
            }
            
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let result = try? JSONDecoder().decode(type, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(result))
        }.resume()
    }
    
    func refreshToken(){
        APIClientManager.shared.request(
            endpoint: "/account/refresh",
            method: "POST",
            body: ["refreshToken":TokenManager.shared.getRefreshToken()],
            type: LoginResponse.self) {[weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
//                    let mainViewController = TabsViewController()
//                    self.navigationController?.pushViewController(mainViewController, animated: true)
//                    self.setLoadingState(false)
                    TokenManager.shared.saveAccessToken(response.accessToken)
                    TokenManager.shared.saveRefreshToken(response.refreshToken)
                    

                    
                    print("Success: \(response.accessToken)")
                case .failure(let error):
                    print("Error: \(error)")
                    //self.setLoadingState(false)

                }
                
            }
         
        }
    }
    
    
    

}
