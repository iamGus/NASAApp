//
//  Rover.swift
//  NASAApp
//
//  Created by Angus Muller on 13/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

struct Rover: JSONDecodable {
  

    let id: Int
    let name: String
    let landingDate: Date
    let launchDate: Date
    let status: String
    let maxSol: Int
    let maxDate: Date
    let totalPhotos: Int
    let cameras: [RoverCamera]
    
    var isRoverActive: Bool {
        if status == "active" {
            return true
        } else {
            return false
        }
    }
    
    init?(json: [String : Any]) {
        struct Key {
            static let roverId = "id"
            static let roverName = "name"
            static let roverLandingDate = "landing_date"
            static let roverLaunchDate = "launch_date"
            static let roverStatus = "status"
            static let roverMaxSol = "max_sol"
            static let roverMaxDate = "max_date"
            static let roverTotalPhotos = "total_photos"
            static let roverCameras = "cameras"
        }
        
        //Checks that keys in JSON exists, contain values and convertible to needed type
        guard let roverId = json[Key.roverId] as? Int,
            let roverName = json[Key.roverName] as? String,
            let roverLandingDate = json[Key.roverLandingDate] as? String,
            let roverLaunchDate = json[Key.roverLaunchDate] as? String,
            let roverStatus = json[Key.roverStatus] as? String,
            let roverMaxSol = json[Key.roverMaxSol] as? Int,
            let roverMaxDate = json[Key.roverMaxDate] as? String,
            let roverTotalPhotos = json[Key.roverTotalPhotos] as? Int,
            let roverCameras = json[Key.roverCameras] as? [[String: Any]] else {
                return nil
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let roverLandingDateValue = formatter.date(from: roverLandingDate),
            let roverLaunchDateValue = formatter.date(from: roverLaunchDate),
            let roverMaxDateValue = formatter.date(from: roverMaxDate) else {
                return nil
        }
        
        
        self.id = roverId
        self.name = roverName
        self.landingDate = roverLandingDateValue
        self.launchDate = roverLaunchDateValue
        self.status = roverStatus
        self.maxSol = roverMaxSol
        self.maxDate = roverMaxDateValue
        self.totalPhotos = roverTotalPhotos
        // Make Camera types
        self.cameras = roverCameras.flatMap { RoverCamera(json: $0) }
        
    }
    
}
