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
    /// Retrieve all rovers from Nasa
    func getRovers(completion: @escaping (Result<[Rover], APIError>) -> Void) {
        
        let endpoint = MarsRoverEndpoint.roverTypes
        let request = endpoint.request
        
        fetch(with: request, parse: { json -> [Rover] in
            guard let allRovers = json["rovers"] as? [[String: Any]] else { return [] }
            return allRovers.flatMap { Rover(json: $0, rover: nil) }
        }, completion: completion)
    }
    
    /// Retrieve images from all rovers
    func getPhotosAll(rovers: [Rover], completion: @escaping (Result<[RoverPhoto], APIError>) -> Void) {
        
        var allRoversPhotos = [RoverPhoto]()
        let dispatchGroup = DispatchGroup()
        
        for rover in rovers {
            
            dispatchGroup.enter()
            
            let roverNameNocaps = rover.name.lowercased()
            let endpoint = MarsRoverEndpoint.imageSearchByRover(rover: roverNameNocaps)
            let request = endpoint.request
            print(request)
                self.fetch(with: request, parse: { json -> [RoverPhoto] in
                guard let allRovers = json["photos"] as? [[String: Any]] else { return [] }
                    return allRovers.flatMap { RoverPhoto(json: $0, rover: rover) }
                
            }) { result in
                switch result {
                case .success(let rovers):
                    allRoversPhotos += rovers // Add photos of that rover to allRoversPhotos
                    dispatchGroup.leave()
                case .failure(let error):
                    
                    //print(errorAccured)
                    completion(Result.failure(error))
                    break
                }
            }
    }
        dispatchGroup.notify(queue: .main) {
            print("in dispatch group notify")
            completion(Result.success(allRoversPhotos))
        }
        //completion(Result.success(allRoversPhotos))
    }
    
}
