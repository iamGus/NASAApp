//
//  LocationSearchClient.swift
//  NASAApp
//
//  Created by Angus Muller on 09/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import MapKit

// Get location results from users eneter string, return mapItems
class LocationSearchClient {
    func search(withTerm term: String, completion: @escaping ([MKMapItem], Error?) -> Void) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = term
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                return completion([], error)
            }
            return completion(response.mapItems, nil)
        }
    }
}
