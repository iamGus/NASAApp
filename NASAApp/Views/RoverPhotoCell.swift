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
    
    var imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        super.init(frame: frame)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.black
        self.contentView.addSubview(imageView)
        
        // Set cell corner radius
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialisation code
        
    }

    
    func configure(with viewModel: RoverPhotoCellViewModel) {
        imageView.image = viewModel.image
    }
    
}
