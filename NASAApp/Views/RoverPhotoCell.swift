//
//  RoverPhotoCell.swift
//  NASAApp
//
//  Created by Angus Muller on 18/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

final class RoverPhotoCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: RoverPhotoCell.self)
    
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialisation code
    }
    
    
    
    func configure(with viewModel: RoverPhotoCellViewModel) {
        photoView.image = viewModel.image
    }
    
}
