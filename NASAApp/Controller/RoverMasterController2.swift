//
//  RoverMasterController2.swift
//  NASAApp
//
//  Created by Angus Muller on 03/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

class RoverMasterController2: UIViewController {
    
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
        //collectionView.register(RoverPhotoCell.self, forCellWithReuseIdentifier: RoverPhotoCell.reuseIdentifier)
        //let nib = UINib(nibName: "RoverPhotoCell", bundle: nil)
        collectionView.register(RoverPhotoCell.self, forCellWithReuseIdentifier: RoverPhotoCell.reuseIdentifier)
        collectionView.dataSource = dataSource
        
        
        //collectionView.delegate = dataSource
        //collectionView?.delegate = self
        
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
    
    
    @IBAction func updateView(_ sender: Any) {
        collectionView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
