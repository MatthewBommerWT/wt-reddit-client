//
//  APIClient.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/18/21.
//

import Foundation

enum APIError: Error {
    case missingData
    case parsingFailed
}

class APIClient {
    
    private let session = URLSession(configuration: .default)
    
    private func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    func performDecodable<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        perform(request: request) { data, response, error in
            guard error == nil, let data = data else {
                completion(Result.failure(error ?? APIError.missingData))
                return
            }
            
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(parsedData))
            } catch {
                completion(Result.failure(error))
            }
        }
    }

}
