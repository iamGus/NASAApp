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
    
    // Progress indicator
    var progressIndicator = ProgressView()
    
    //  Add progress to subview
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
        
        // Start progress indicator animating
        progressIndicator.startAnimating()
        
        // Call nasa api to get rover types
        getRoverTypes()
    }
    
    /// Get Rover Types from Nasa Api
    func getRoverTypes() {
        client.getRovers() { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.rovers = rovers
                self?.cameras = RoverCamera.addCamerasAndRemoveDups(rovers: rovers)
                
                //Now get all images for the rovers
                self?.getAllRoversPhotos()
            case.failure(let error):
                self?.progressIndicator.stopAnimating()
                self?.showAlert(title: "Alert", message: "Could not get rover data, more details: \(error.errorDescription)")
            }
        }
    }
    
    /// After rover types have been downloaded this function gets all images for all rovers
    func getAllRoversPhotos() {
        guard let allRovers = rovers else {
            // As rover types have their own error checking this should not happen but in place just in case
            showAlert(title: "Alert", message: "Sorry could not get images data for the rovers")
            return
        }
        // Download all rover images
        client.getPhotosAll(rovers: allRovers) { [weak self]  result in
            switch result {
            case .success(let photos):
                // Add all photo data to datasource and update colection view
                self?.dataSource.update(with: photos)
                self?.collectionView!.reloadData()
                self?.progressIndicator.stopAnimating()
            case .failure(let error):
                self?.progressIndicator.stopAnimating()
                self?.showAlert(title: "Alert", message: "Could not get Mars images data, more details: \(error.errorDescription)")
            }
        }
    }
    
    
  
    // MARK: - Navigation
    
    // Show Rover Detail view for that image
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
    
    @IBAction func backHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
 

}
