//
//  SinglePhotoDownloader.swift
//  NASAApp
//
//  Created by Angus Muller on 23/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

class SinglePhotoDownloader {
    
    func downloadImage(url: URL, completion: @escaping (ImageResult<UIImage, String>) -> Void) {
        //progress.startAnimating()
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    guard let image = (UIImage(data: data)) else {
                        return completion(ImageResult.failure("Could not convert data to image type"))
                    }
                    completion(ImageResult.success(image))
                    //self.progress.stopAnimating()
                }
                
                // If cannot get image form internet then inform user
            } catch let error {
                //self.progress.stopAnimating()
                completion(ImageResult.failure(error.localizedDescription))
            }
        }
    }
}
