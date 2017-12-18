//
//  RoverDataSource.swift
//  NASAApp
//
//  Created by Angus Muller on 18/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class RoverDataSource: NSObject, UICollectionViewDataSource {
    
    private let collectionView: UICollectionView
    private var data = [RoverPhoto]()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func update(with rovers: [RoverPhoto]) {
        data = rovers
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverPhotoCell.reuseIdentifier, for: indexPath) as! RoverPhotoCell
        
        let rover = data[indexPath.row]
        //photoCell.photoView = rover.
        
        return photoCell
    }
    
    // MARK: - Helper
    
    // Return just that Rover for that selected row
    func rover(at indexPath: IndexPath) -> RoverPhoto {
        return data[indexPath.row]
    }
    
    
}
