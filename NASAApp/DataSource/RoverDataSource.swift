//
//  RoverDataSource.swift
//  NASAApp
//
//  Created by Angus Muller on 18/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class RoverDataSource: NSObject, UICollectionViewDataSource {
    
    private var data = [RoverPhoto]()
    
    let pendingOperations = PendingOperations() // NOTE make private?
    private var collectionView: UICollectionView
    
    
    init(roverPhotos: [RoverPhoto], collectionView: UICollectionView) {
        self.data = roverPhotos
        self.collectionView = collectionView
        super.init()
    }
    
    // MARK: - Data Source
    
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
        
        let roverPhoto = data[indexPath.row]
        let viewModel = RoverPhotoCellViewModel(roverPhoto: roverPhoto) // Get viewmodel of cell
        
        photoCell.configure(with: viewModel) // pass viewmodel of cell to cell view
        
        if roverPhoto.photoState == .placeholder {
            downloadPhotoForRover(roverPhoto, atIndexPath: indexPath)
        }
        
        return photoCell
    }
    
    // MARK: - Helper
    
    // Return just that Rover for that selected row
    func roverImage(at indexPath: IndexPath) -> RoverPhoto {
        return data[indexPath.row]
    }
    
    func downloadPhotoForRover(_ roverPhoto: RoverPhoto, atIndexPath indexPath: IndexPath) {
        //If Operation for that cell in already in progress then return
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = PhotoDownloader(roverPhoto: roverPhoto)
        
        // Run photo downloader on completion block
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                // Update pending operations class
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
        
    }
    
    
}
