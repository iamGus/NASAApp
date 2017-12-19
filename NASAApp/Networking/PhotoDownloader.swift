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
import ImageIO

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
        
        let options: [NSString: NSObject] = [
            kCGImageSourceThumbnailMaxPixelSize: max(20, 20) as NSObject,
            kCGImageSourceCreateThumbnailFromImageAlways: true as NSObject,
            kCGImageSourceCreateThumbnailWithTransform: true as NSObject
        ]
        
        guard let imageData = CGImageSourceCreateWithURL(roverPhoto.photoUrl as CFURL, options as CFDictionary) else {
            roverPhoto.photoState = .failed
            return
        }
        
        if self.isCancelled {
            return
        }
        
        createThumbnailImage(data: imageData, imageSize: 20)
        
    }
     
    
}

extension PhotoDownloader {
    
    func createThumbnailImage(data: CGImageSource, imageSize:Int) {
        
        

        
        // Create an image source from NSData; no options.
        //if let imgSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            
            
            // Create the thumbnail image using the specified options.
            
            // Set up the thumbnail options.
            let options: [NSString: NSObject] = [
                kCGImageSourceThumbnailMaxPixelSize: max(20, 20) as NSObject,
                kCGImageSourceCreateThumbnailFromImageAlways: true as NSObject,
                kCGImageSourceCreateThumbnailWithTransform: true as NSObject
            ]
            
            if let imageThumbnail = CGImageSourceCreateThumbnailAtIndex(data, 0, options as CFDictionary) {
                print("working")
                roverPhoto.photo = UIImage(cgImage: imageThumbnail)
                roverPhoto.photoState = .downloaded
            } else {
                print("Thumbnail image not created from image source.")
            }
       
        
        return
    }
}
