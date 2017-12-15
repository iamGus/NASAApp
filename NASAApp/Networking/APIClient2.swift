/*
//
//  APIClient2.swift
//  NASAApp
//
//  Created by Angus Muller on 14/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation
//
//  APIClient.swift
//  NASAApp
//
//  Created by Angus Muller on 13/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

// API Error cases
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    //Readable description of error
    var errorDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

protocol APIClient {
    var session: URLSession { get }
    
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (JSON) -> [T], completion: @escaping (Result<[T], APIError>) -> Void)
}

extension APIClient {
    
    
    
    
    /// Returns instance of URLSessionDataTask with raw data
    private func jsonTask(with request: URLRequest, completionHandler completion: @escaping (Data?, APIError?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    completion(data, nil)
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        
        return task
    }
    /// Generic method to call jsonTask and see if data can be parsed, if it can then return JSON
    func fetch<T: Codable>(with request: URLRequest, model: T.Type, parse: @escaping (T) -> [T], completion: @escaping (Result<[T], APIError>) -> Void) {
        let task = jsonTask(with: request) { json, error in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData)) // If no specific error message give generic error
                    }
                    
                    return // return from error
                }
                
                // parse data from input struct type
                do {
                    let decoder = JSONDecoder()
                    let object = try decoder.decode([model].self, from: json)
                    
                    completion(Result.success(object))
                    
                } catch {
                    completion(Result.failure(.jsonParsingFailure))
                }
            }
        }
        
        task.resume()
    }
    
}
*/
