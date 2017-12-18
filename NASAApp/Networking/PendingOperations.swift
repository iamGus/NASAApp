//
//  PendingOperations.swift
//  NASAApp
//
//  Created by Angus Muller on 18/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

class PendingOperations {
    // Tracking each image download operation with cell indexpath
    var downloadsInProgress = [IndexPath: Operation]()
    
    var downloadQueue = OperationQueue()
    
}

