//
//  RoverMasterController2.swift
//  NASAApp
//
//  Created by Angus Muller on 03/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

class RoverMasterController2: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var dataSource: RoverDataSource = {
        return RoverDataSource(roverPhotos: [], collectionView: self.collectionView) 
    }()
    
    // Rover Properties from Nasa API
    var rovers: [Rover]?
    var cameras: [RoverCamera]?
    let client = NASAClient()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(RoverPhotoCell.self, forCellWithReuseIdentifier: RoverPhotoCell.reuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        // Get Genre data from tmdb and update datasource
        client.getRovers() { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.rovers = rovers
                self?.cameras = RoverCamera.addCamerasAndRemoveDups(rovers: rovers)
                self?.getAllRoversPhotos()
            case.failure(let error):
                switch error {
                case .requestFailed: print("request failed")
                case .responseUnsuccessful: print("\(APIError.responseUnsuccessful.errorDescription)")
                case .invalidData: print("\(APIError.invalidData.errorDescription)")
                case .jsonConversionFailure: print("\(APIError.jsonConversionFailure.errorDescription)")
                case .jsonParsingFailure: print("\(APIError.jsonParsingFailure.errorDescription)")
                }
            }
        }
    }

    func getAllRoversPhotos() {
        guard let allRovers = rovers else {
            // Add error that rovers could not be loaded
            return
        }
        
        client.getPhotosAll(rovers: allRovers) { [weak self]  result in
            switch result {
            case .success(let photos):
                self?.dataSource.update(with: photos)
                self?.collectionView!.reloadData()
            //self?.dataSource.update(collectionView: (self?.collectionView)!)
            case .failure(let error):
                switch error{
                case .requestFailed: print("request failed")
                case .responseUnsuccessful: print("\(APIError.responseUnsuccessful.errorDescription)")
                case .invalidData: print("\(APIError.invalidData.errorDescription)")
                case .jsonConversionFailure: print("\(APIError.jsonConversionFailure.errorDescription)")
                case .jsonParsingFailure: print("\(APIError.jsonParsingFailure.errorDescription)")
                }
            }
        }
    }
    
    
  
    // MARK: - Navigation
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "RoverDetail", sender: collectionView.cellForItem(at: indexPath))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoverDetail" {
            print(sender.debugDescription)
            if let cell = sender as? RoverPhotoCell, let indexPath = collectionView.indexPath(for: cell), let detailController = segue.destination as? RoverDetailController {
                
                detailController.roverPhoto = dataSource.roverImage(at: indexPath)
            } else {
                // Error handling
            }
        }
    }
 

}
