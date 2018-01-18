//
//  RoverMasterController2.swift
//  NASAApp
//
//  Created by Angus Muller on 03/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

class RoverMasterController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var dataSource: RoverDataSource = {
        return RoverDataSource(roverPhotos: [], collectionView: self.collectionView) 
    }()
    
    // Rover Properties from Nasa API
    var rovers: [Rover]?
    var cameras: [RoverCamera]?
    let client = NASAClient()
    
    var progressIndicator = ProgressView()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(progressIndicator)
        view.bringSubview(toFront: progressIndicator)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup progress message
        progressIndicator = ProgressView(frame: view.bounds)
       
        // Setup collection view
        collectionView.register(RoverPhotoCell.self, forCellWithReuseIdentifier: RoverPhotoCell.reuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        // Get Rover types from Nasa Api
        progressIndicator.startAnimating()
        client.getRovers() { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.rovers = rovers
                self?.cameras = RoverCamera.addCamerasAndRemoveDups(rovers: rovers)
                
                //Now get all images for the rovers
                self?.getAllRoversPhotos()
            case.failure(let error):
                switch error {
                case .requestFailed: self?.showAlert(title: "Alert", message: "Could not get rover data, more details: \(APIError.requestFailed.errorDescription)")
                case .responseUnsuccessful: self?.showAlert(title: "Alert", message: "Could not get rover data, more details: \(APIError.responseUnsuccessful.errorDescription)")
                case .invalidData: self?.showAlert(title: "Alert", message: "Could not get rover data, more details: \(APIError.invalidData.errorDescription)")
                case .jsonConversionFailure: self?.showAlert(title: "Alert", message: "Could not get rover data, more details: \(APIError.jsonConversionFailure.errorDescription)")
                case .jsonParsingFailure: self?.showAlert(title: "Alert", message: "Could not get rover data, more details: \(APIError.jsonParsingFailure.errorDescription)")
                
                // If error once shown popup stop loading indicator
                defer {
                    self?.progressIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    /// After rover types have been downlaoded this function gets all images for all rovers
    func getAllRoversPhotos() {
        guard let allRovers = rovers else {
            // As rover types have its own error checking so this should not happen but in place just in case
            showAlert(title: "Alert", message: "Sorry could not get images data for the rovers")
            return
        }
        
        client.getPhotosAll(rovers: allRovers) { [weak self]  result in
            switch result {
            case .success(let photos):
                // Add all photo data to datasource and update colection view
                self?.dataSource.update(with: photos)
                self?.collectionView!.reloadData()
                self?.progressIndicator.stopAnimating()
            //self?.dataSource.update(collectionView: (self?.collectionView)!)
            case .failure(let error):
                switch error {
                case .requestFailed: self?.showAlert(title: "Alert", message: "Could not get mars images data, more details: \(APIError.requestFailed.errorDescription)")
                case .responseUnsuccessful: self?.showAlert(title: "Alert", message: "Could not get mars images data, more details: \(APIError.responseUnsuccessful.errorDescription)")
                case .invalidData: self?.showAlert(title: "Alert", message: "Could not get mars images data, more details: \(APIError.invalidData.errorDescription)")
                case .jsonConversionFailure: self?.showAlert(title: "Alert", message: "Could not get mars images data, more details: \(APIError.jsonConversionFailure.errorDescription)")
                case .jsonParsingFailure: self?.showAlert(title: "Alert", message: "Could not get mars images data, more details: \(APIError.jsonParsingFailure.errorDescription)")
                
                // If error once shown popup stop loading indicator
                defer {
                    self?.progressIndicator.stopAnimating()
                    }
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
                print("Unable to collect all needed data for Detail view controller")
            }
        }
    }
 

}
