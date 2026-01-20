//
//  DreamApiMAnager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 1/18/26.
//

 import Foundation

 class DreamApiManager{

     static let  shared  = DreamApiManager()
     private let dreamsBaseURL = "http://localhost:5142/api" //"https://dreams-api.dream-if-y.us/api" // Your dreams service URL

     private var authToken:String?


     private init(){}
     // MARK: - Authentication
     func setToken(_ token: String) {
         self.authToken = token
     }

     func clearToken() {
         self.authToken = nil
     }

     func uploadDream(
         audioURL: URL,
         fileName: String,
         tag: String,
         transcribedText: String,
         //analyzedText: String,
         completion: @escaping (Result<DreamUploadResponse, APIError>) -> Void
     ) {
         guard let token = TokenManager.shared.getAccessToken() else {
             completion(.failure(.authenticationError))
             return
         }
         
         guard let url = URL(string: "\(dreamsBaseURL)/Bucket/upload") else {
             completion(.failure(.invalidURL))
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         
         let boundary = "Boundary-\(UUID().uuidString)"
         request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
         
         var body = Data()
         
         // Add file
         do {
             let audioData = try Data(contentsOf: audioURL)
             body.append("--\(boundary)\r\n")
             body.append("Content-Disposition: form-data; name=\"File\"; filename=\"\(fileName).m4a\"\r\n") // Use actual fileName
             body.append("Content-Type: audio/aac\r\n\r\n")
             body.append(audioData)
             body.append("\r\n")
         } catch {
             completion(.failure(.networkError))
             return
         }
         
         // Add FileName
         body.append("--\(boundary)\r\n")
         body.append("Content-Disposition: form-data; name=\"FileName\"\r\n\r\n")
         body.append("\(fileName)\r\n")
         // Add Title
         body.append("--\(boundary)\r\n")
         body.append("Content-Disposition: form-data; name=\"Title\"\r\n\r\n")
         body.append("\(fileName)\r\n")
         
         // Add Tag (required)
         body.append("--\(boundary)\r\n")
         body.append("Content-Disposition: form-data; name=\"Tag\"\r\n\r\n")
         body.append("\(tag)\r\n")
         
         // Add TranscribedText (required)
         body.append("--\(boundary)\r\n")
         body.append("Content-Disposition: form-data; name=\"TranscribedText\"\r\n\r\n")
         body.append("\(transcribedText)\r\n")
         
         

         
         // Add CreatedAt (required)
         let isoFormatter = ISO8601DateFormatter()
         body.append("--\(boundary)\r\n")
         body.append("Content-Disposition: form-data; name=\"CreatedAt\"\r\n\r\n")
         body.append("\(isoFormatter.string(from: Date()))\r\n")
         
         body.append("--\(boundary)--\r\n")
         
         request.httpBody = body
         
         URLSession.shared.dataTask(with: request) { data, response, error in
             if error != nil {
                 completion(.failure(.networkError))
                 return
             }
             
             let res = response as? HTTPURLResponse
             print("printing res code:\(res?.statusCode)")
             guard let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 200 && httpResponse.statusCode < 300,
                   let data = data else {
                 // print(httpResponse.statusCode)
                 
                 completion(.failure(.networkError))
                 
                     return
             }
             print(httpResponse.statusCode)
             
             guard let result = try? JSONDecoder().decode(DreamUploadResponse.self, from: data) else {
                 completion(.failure(.decodingError))
                 return
             }
             
             completion(.success(result))
         }.resume()
     }

     // Download recording
     func downloadDream(
         dreamId: String,
         completion: @escaping (Result<URL, APIError>) -> Void
     ) {
         guard let token = TokenManager.shared.getAccessToken() else {
             completion(.failure(.authenticationError))
             return
         }

         guard let url = URL(string: "\(dreamsBaseURL)/dreams/\(dreamId)/download") else {
             completion(.failure(.invalidURL))
             return
         }

         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

         URLSession.shared.dataTask(with: request) { data, response, error in
             if error != nil {
                 completion(.failure(.networkError))
                 return
             }

             guard let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 200 && httpResponse.statusCode < 300,
                   let data = data else {
                 completion(.failure(.networkError))
                 return
             }

             // Save to Documents directory
             let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
             let localURL = documentsURL.appendingPathComponent("\(dreamId).aac")

             do {
                 try data.write(to: localURL)
                 completion(.success(localURL))
             } catch {
                 completion(.failure(.networkError))
             }
         }.resume()
     }
     // get dreams
     func getDreams(completion: @escaping (Result<[DreamMetadata], APIError>) -> Void) {
         guard let token = TokenManager.shared.getAccessToken() else {
             completion(.failure(.authenticationError))
             return
         }

         guard let url = URL(string: "\(dreamsBaseURL)/dreams") else {
             completion(.failure(.invalidURL))
             return
         }

         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

         URLSession.shared.dataTask(with: request) { data, response, error in
             if error != nil {
                 completion(.failure(.networkError))
                 return
             }

             guard let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 200 && httpResponse.statusCode < 300,
                   let data = data else {
                 completion(.failure(.networkError))
                 return
             }

             guard let result = try? JSONDecoder().decode([DreamMetadata].self, from: data) else {
                 completion(.failure(.decodingError))
                 return
             }

             completion(.success(result))
         }.resume()
     }


     func deleteDream(
         dreamId: String,
         completion: @escaping (Result<Void, APIError>) -> Void
     ) {
         guard let token = TokenManager.shared.getAccessToken() else {
             completion(.failure(.authenticationError))
             return
         }

         guard let url = URL(string: "\(dreamsBaseURL)/dreams/\(dreamId)") else {
             completion(.failure(.invalidURL))
             return
         }

         var request = URLRequest(url: url)
         request.httpMethod = "DELETE"
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

         URLSession.shared.dataTask(with: request) { _, response, error in
             if error != nil {
                 completion(.failure(.networkError))
                 return
             }

             guard let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                 completion(.failure(.networkError))
                 return
             }

             completion(.success(()))
         }.resume()
     }

 }

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

