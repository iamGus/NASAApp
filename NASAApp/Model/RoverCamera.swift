//
//  Cameras.swift
//  NASAApp
//
//  Created by Angus Muller on 13/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

struct RoverCamera {
    let name: String
    let fullName: String
    var roverID: [Int]
}

extension RoverCamera: JSONDecodable {
    init?(json: [String: Any]) {
        struct Key {
            static let cameraName = "name"
            static let cameraFullName = "full_name"
            static let cameraRoverID = "rover_id"
        }
        
        guard let cameraName = json[Key.cameraName] as? String,
            let cameraFullName = json[Key.cameraFullName] as? String else {
                return nil
        }
        
        if let cameraRoverID = json[Key.cameraRoverID] as? Int {
            self.roverID = [cameraRoverID]
        } else {
            self.roverID = []
        }
        
        self.name = cameraName
        self.fullName = cameraFullName
       
    }
    
}

extension RoverCamera {
    
    /// Gets cameras from all rovers and returns cameras with no duplicates plus icludes the rover ID in each camera that the rover can use.
    static func addCamerasAndRemoveDups(rovers: [Rover]) -> [RoverCamera] {
        
        var combinedCameras = [RoverCamera]()
        var encounted = Set<String>()
        var results = [RoverCamera]()
        
        // Add all rover cameras to one array
        for rover in rovers {
            combinedCameras += rover.cameras
        }
        
        // Add rover ID to camera so we know we can use this camera with that rover
        // Do feel this is a bit of a tree of doom! Try to improve later
        for rover in rovers {
            for camera in rover.cameras {
                for (index, eachCombinedCamera) in combinedCameras.enumerated() {
                    if camera.name == eachCombinedCamera.name {
                        combinedCameras[index].roverID.append(rover.id)
                    }
                }
            }
        }
        
        // Create results array with no duplicate cameras
        for camera in combinedCameras {
            if encounted.contains(camera.name) {
                // Do not add a duplicate element
            } else {
                //Add camera name to the set
                encounted.insert(camera.name)
                //Now add RoverCamera to result array
                results.append(camera)
            }
        }
        
        return results
    }
    
    
}
