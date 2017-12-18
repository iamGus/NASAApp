//
//  PhotoDownloader.swift
//  NASAApp
//
//  Created by Angus Muller on 18/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation


import Foundation
import UIKit

class PhotoDownloader: Operation {
    var roverPhoto: RoverPhoto
    
    init(roverPhoto: RoverPhoto) {
        self.roverPhoto = roverPhoto
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        do {
            let imageData = try Data(contentsOf: roverPhoto.photoUrl)
            
            if self.isCancelled {
                return
            }
            
            // If image data has data and can be put into type of UIImage
            if imageData.count > 0 && (UIImage(data: imageData) != nil) {
                roverPhoto.photo = UIImage(data: imageData)
                roverPhoto.photoState = .downloaded
                // If this does not work then mark as failed
            } else {
                roverPhoto.photoState = .failed
            }
            
        } catch let error {
            roverPhoto.photoState = .failed
            print("image error catch: \(error)") // NOTE add better error handling
            return
        }
    }
    
}
