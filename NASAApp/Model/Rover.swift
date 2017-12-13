//
//  Rover.swift
//  NASAApp
//
//  Created by Angus Muller on 13/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

class Rover {
    let id: Int
    let name: String
    let landingDate: Date
    let launchDate: Date
    let status: Bool
    let maxSol: Int
    let maxDate: Date
    let totalPhotos: Int
    let cameras: [Camera]
    
    init(id: Int, name: String, landingDate: Date, launchDate: Date, status: Bool, maxSol: Int, maxDate: Date, totalPhotos: Int, cameras: [Camera]) {
        self.id = id
        self.name = name
        self.landingDate = landingDate
        self.launchDate = launchDate
        self.status = status
        self.maxSol = maxSol
        self.maxDate = maxDate
        self.totalPhotos = totalPhotos
        self.cameras = cameras
    }
    
}
