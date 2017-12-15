//
//  NasaClient.swift
//  NASAApp
//
//  Created by Angus Muller on 13/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//


import Foundation

class NASAClient: APIClient {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    /// Retrieve all genres from TMDb
    func getRovers(completion: @escaping (Result<[Rover], APIError>) -> Void) {
        
        let endpoint = MarsRoverEndpoint.roverTypes
        let request = endpoint.request
        
        fetch(with: request, parse: { json -> [Rover] in
            guard let allRovers = json["rovers"] as? [[String: Any]] else { return [] }
            return allRovers.flatMap { Rover(json: $0) }
        }, completion: completion)
    }
    
}
