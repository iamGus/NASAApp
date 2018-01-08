//
//  RoverDetailController.swift
//  NASAApp
//
//  Created by Angus Muller on 08/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

class RoverDetailController: UIViewController {
    
    @IBOutlet weak var roverPhotoView: UIImageView!
    
    
    var roverPhoto: RoverPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let fullSizeImage = roverPhoto {
            roverPhotoView.image = fullSizeImage.photo
        }
    }

  

}
