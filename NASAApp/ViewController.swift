//
//  ViewController.swift
//  NASAApp
//
//  Created by Angus Muller on 12/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var rovers = [Rover]()
    var cameras = [RoverCamera]()
    let client = NASAClient()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Genre data from tmdb and update datasource
        client.getRovers() { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.rovers = rovers
                self?.seeResults()
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
    
    func seeResults() {
        for rover in rovers {
            print("Name: \(rover.name)")
            print("Cameras: \(rover.cameras.count)")
            print("-------------")
        }
        
        for rover in rovers {
            for camera in rover.cameras {
                
            }
        }
        
        print(cameras.count)
        
    }


}

