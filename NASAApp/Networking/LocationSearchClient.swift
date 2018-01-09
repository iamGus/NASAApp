//
//  LocationSearchClient.swift
//  NASAApp
//
//  Created by Angus Muller on 09/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import MapKit

class LocationSearchClient {
    func search(withTerm term: String, completion: @escaping ([MKMapItem], Error?) -> Void) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = term
        //request.region.center = coordinate
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                return completion([], error)
            }
            return completion(response.mapItems, nil)
        }
    }
}
