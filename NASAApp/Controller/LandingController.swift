//
//  LandingController.swift
//  NASAApp
//
//  Created by Angus Muller on 12/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class LandingController: UIViewController {
    
    var rovers = [Rover]()
    var cameras = [RoverCamera]()
    let client = NASAClient()
    var allPhotos = [RoverPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Genre data from tmdb and update datasource
        client.getRovers() { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.rovers = rovers
                self?.cameras = RoverCamera.addCamerasAndRemoveDups(rovers: rovers)
                self?.testPrint()
                self?.getAllRoversPhotos()
            case.failure(let error):
                switch error {
                case .requestFailed: print("request failed")
                case .responseUnsuccessful: print("\(APIError.responseUnsuccessful.errorDescription)")
                case .invalidData: print("\(APIError.invalidData.errorDescription)")
                case .jsonConversionFailure: print("\(APIError.jsonConversionFailure.errorDescription)")
                case .jsonParsingFailure: print("\(APIError.jsonParsingFailure.errorDescription)")
                }
            }
        }
        
       
        
    }
    
    func testPrint() {
        for rover in rovers {
            print("Name: \(rover.name)")
            print("Id: \(rover.id)")
            print("Cameras: \(rover.cameras.count)")
            print("-------------")
        }
        
       print(cameras.count)
    }
    
    func getAllRoversPhotos() {
        client.getPhotosAll(rovers: rovers) { [weak self]  result in
            switch result {
            case .success(let photos):
                self?.allPhotos = photos
                self?.testPrint2()
            case .failure(let error):
                switch error{
                case .requestFailed: print("request failed")
                case .responseUnsuccessful: print("\(APIError.responseUnsuccessful.errorDescription)")
                case .invalidData: print("\(APIError.invalidData.errorDescription)")
                case .jsonConversionFailure: print("\(APIError.jsonConversionFailure.errorDescription)")
                case .jsonParsingFailure: print("\(APIError.jsonParsingFailure.errorDescription)")
                }
            }
        }
    }
    
    func testPrint2() {
        print(allPhotos.count)
    }


}

