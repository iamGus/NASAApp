//
//  earthTableView.swift
//  NASAApp
//
//  Created by Angus Muller on 18/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import UIKit

class EarthTableView: UITableView {
    
    var height = 1.0

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 1.0, height: height)
    }

}
