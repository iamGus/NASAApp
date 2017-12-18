//
//  RoverPhoto.swift
//  NASAApp
//
//  Created by Angus Muller on 15/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation
import UIKit

enum RoverImageState {
    case placeholder
    case downloaded
    case failed
}

struct RoverPhoto {
    let id: Int
    let sol: Int
    let earthDate: Date
    let camera: RoverCamera
    let photoUrl: URL
    var photo: UIImage?
    var photoState = RoverImageState.placeholder
}

extension RoverPhoto: JSONDecodable {
    init?(json: [String : Any]) {
        struct Key {
            static let photoID = "id"
            static let photoSol = "sol"
            static let photoCamera = "camera"
            static let photoUrl = "img_src"
            static let photoEarthDate = "earth_date"
        }
        
        guard let photoID = json[Key.photoID] as? Int,
            let photoSol = json[Key.photoSol] as? Int,
            let photoEarthDate = json[Key.photoEarthDate] as? String,
            let photoUrlString = json[Key.photoUrl] as? String,
            let photoUrl = URL(string: photoUrlString) else {
                return nil
        }
        
        // Make type for camera data
        guard let photoCamera = json[Key.photoCamera] as? [String: Any], let photoCameraAsType = RoverCamera(json: photoCamera) else {
            return nil
        }
        
        // Format date into date format
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let PhotoEarthDateValue = formatter.date(from: photoEarthDate) else {
                return nil
        }
        
        self.id = photoID
        self.sol = photoSol
        self.earthDate = PhotoEarthDateValue
        self.camera = photoCameraAsType
        self.photoUrl = photoUrl
        self.photo = nil
        
    }
}
