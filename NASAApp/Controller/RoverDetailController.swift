//
//  RoverDetailController.swift
//  NASAApp
//
//  Created by Angus Muller on 08/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

// Currently images are not catched, in production app could use libary like Kingfisher to cache images to stop possible multiple downloads.

import UIKit

class RoverDetailController: UIViewController {
    
    @IBOutlet weak var roverPhotoView: UIImageView!
    
    
    var roverPhoto: RoverPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let fullSizeImage = roverPhoto, let url = URL(string: fullSizeImage.photoUrl) {
            roverPhotoView.image = fullSizeImage.photo
        
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.roverPhotoView.image = UIImage(data: data!)
                }
            }
        }
    }

  

}
