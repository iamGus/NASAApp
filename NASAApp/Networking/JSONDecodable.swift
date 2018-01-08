//
//  JSONDecodable.swift
//  NASAApp
//
//  Created by Angus Muller on 13/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    /// Instantiates an instance of the conforming type with a JSON dictionary
    ///
    /// Returns `nil` if the JSON dictionary does not contain all the values
    /// needed for instantiation of the conforming type
    // Note this could be enhanced by creating seperate init for rovers so that Rover and Camera models do not have to have the rover type in the init
    init?(json: [String: Any], rover: Rover?)
}


