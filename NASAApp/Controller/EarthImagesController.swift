//
//  EarthImagesController.swift
//  NASAApp
//
//  Created by Angus Muller on 09/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

class EarthImagesController: UIViewController {

    @IBOutlet weak var searchViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var earthImageView: UIImageView!
    
    var searchController: UISearchController!
    var searchClient = LocationSearchClient()
    let dataSource = LocationSearchDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tableview
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        // Setup search bar
        configureSearchController()
    }

}


// MARK: Serach Bar and table results

extension EarthImagesController: UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
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
}
