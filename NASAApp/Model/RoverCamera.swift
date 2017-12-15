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
}

extension RoverCamera: JSONDecodable {
    init?(json: [String: Any]) {
        struct Key {
            static let cameraName = "name"
            static let cameraFullName = "full_name"
        }
        
        guard let cameraName = json[Key.cameraName] as? String,
            let cameraFullName = json[Key.cameraFullName] as? String else {
                return nil
        }
        
        self.name = cameraName
        self.fullName = cameraFullName
    }
}
