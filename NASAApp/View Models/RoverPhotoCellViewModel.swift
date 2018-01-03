//
//  RoverPhotoCellViewModel.swift
//  NASAApp
//
//  Created by Angus Muller on 18/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation
import UIKit

struct RoverPhotoCellViewModel {
    let image: UIImage
}

extension RoverPhotoCellViewModel {
    init(roverPhoto: RoverPhoto) {
        // If rover photo state marked as downloaded then use rover image, otherwise use placeholder
        
        self.image = roverPhoto.photoState == .downloaded ? roverPhoto.photo! : #imageLiteral(resourceName: "black_photo_btn")
        
    }
}
