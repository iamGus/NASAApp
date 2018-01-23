//
//  NasaClient.swift
//  NASAApp
//
//  Created by Angus Muller on 13/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//


import Foundation
import MapKit

class NASAClient: APIClient {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    /*
    // For unit testing with test seesion
    convenience init(session: URLSession) {
        self.init(configuration: .default)
        self.session = session
    }
 */
    
    /// Retrieve all rovers from Nasa
    func get(url: URL, completion: @escaping (Result<[Rover], APIError>) -> Void) {
        
        //let endpoint = NasaEndpoint.roverTypes
        let request = URLRequest(url: url)
        
        fetch(with: request, parse: { json -> [Rover] in
            guard let allRovers = json["rovers"] as? [[String: Any]] else { return [] }
            return allRovers.flatMap { Rover(json: $0, rover: nil) }
        }, completion: completion)
    }
    
    
    /// Retrieve all rovers from Nasa
    func getRovers(completion: @escaping (Result<[Rover], APIError>) -> Void) {
        
        let endpoint = NasaEndpoint.roverTypes
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
            let endpoint = NasaEndpoint.imageSearchByRover(rover: roverNameNocaps)
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
    
    func getEarthImage(coordinates: CLLocationCoordinate2D, completion: @escaping (Result<[EarthImage], APIError>) -> Void) {
        
        let endpoint = NasaEndpoint.earthImages(long: coordinates.longitude, lat: coordinates.latitude)
        let request = endpoint.request
        
        fetch(with: request, parse: { json -> [EarthImage] in
            guard let earthImage = json as? [String: Any] else { return [] }
            guard let eartchImage2 = EarthImage(json: earthImage, rover: nil) else { return [] }
            return [eartchImage2]
        }, completion: completion)
    }
    
}
