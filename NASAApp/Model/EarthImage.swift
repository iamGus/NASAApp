//
//  EarthImage.swift
//  NASAApp
//
//  Created by Angus Muller on 09/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import Foundation
import UIKit

class EarthImage: JSONDecodable {
    let url: URL
    let date: String
    
    required init?(json: [String : Any], rover: Rover?) {
        guard let imageUrlString = json["url"] as? String,
        let imageUrl = URL(string: imageUrlString),
            let imageDate = json["date"] as? String else {
                return nil
        }
        
        self.url = imageUrl
        self.date = imageDate
    }
    

    
}
