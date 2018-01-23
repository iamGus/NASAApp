//
//  EarthImagesController.swift
//  NASAApp
//
//  Created by Angus Muller on 09/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit
import MapKit


class EarthImagesController: UIViewController {

    @IBOutlet weak var searchViewContainer: UIView!
    @IBOutlet weak var tableView: EarthTableView!
    @IBOutlet weak var earthImageView: EarthImageView!
    
    // Properties
    var searchController: UISearchController!
    var searchClient = LocationSearchClient()
    var earthImageClient = NASAClient()
    let dataSource = LocationSearchDataSource()
    let photoClient = SinglePhotoDownloader()
        // Progress Indicator
    var progress = ProgressView()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Setup progress message
        progress = ProgressView(frame: earthImageView.bounds)
        earthImageView.addSubview(progress)
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tableview
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.height = 0.5
        earthImageView.height = 2.5
        
        // Setup search bar
        configureSearchController()
    }
    
    @IBAction func backHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
}


// MARK: Serach Bar and table results

extension EarthImagesController: UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // Not used but needed required to be in implermentation
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    /// Setup search bar
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for places"
        searchController.searchBar.delegate = self
        searchViewContainer.addSubview(searchController.searchBar)
    }
    
    // When user begins to enter text into search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchClient.search(withTerm: searchText) { (mapItems, error) in
            
            // If there is no internet connection this error notice is triggered, note though the apple map kit takes too long to bring back this error so would need to inhance this so error somes back quicker in a production app.
            if let searchError = error  {
                // Needs more testing before activating the below
                //self.searchController.isActive = false
                //self.showAlert(title: "Error searching", message: "Unable to retrive search data, please check you ahve an internet conenction")
                print("Error retrieving search data: \(searchError)")
                return
            }
            
            self.dataSource.update(with: mapItems)
            self.tableView.reloadData()
            
        }
    }
    
    // Table cell clicked, update imageView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deativates searh controller so that tableview cells are clickable
        if searchController.isActive == true {
            searchController.isActive = false
        }
        
        let place = dataSource.object(at: indexPath).placemark.coordinate
        getAndUpdateImageData(with: place) // Get and show image
        
    }
    
}

// MARK: earthImage call to API and display
extension EarthImagesController {
    
    // Get image aata (URL)
    func getAndUpdateImageData(with placemark: CLLocationCoordinate2D) {
        earthImageClient.getEarthImage(coordinates: placemark) { [weak self] (result) in
            switch result {
            case .success(let earthImage):
                if earthImage.count == 1 { // Only one image should ever be returned, but check just in case
                    self?.downloadImage(url: earthImage[0].url) // as only one image will be returned get first elemnt in array (only element)
                }
            case .failure(let error):
                self?.showAlert(title: "Alert", message: "Could not get earth image data, more details: \(error.errorDescription)")
            }
        }
    }
    
    // Download image from given url
    func downloadImage(url: URL) {
        progress.startAnimating() // Start progress indicator
        photoClient.downloadImage(url: url) { [weak self] (result) in
            switch result {
            case .success(let image):
                self?.earthImageView.image = image
                self?.progress.stopAnimating()
            case .failure(let error):
                self?.progress.stopAnimating()
                print("Error getting image from internet: \(error)")
                self?.showAlert(title: "Error: Could not load image", message: "Sorry unable to load full size image, please check your internet connection")
            }
        }
    }
}
