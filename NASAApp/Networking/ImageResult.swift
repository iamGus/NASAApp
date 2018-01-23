//
//  ImageResult.swift
//  NASAApp
//
//  Created by Angus Muller on 23/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import Foundation

/// Results come through this enum allowing easy switch statement on success or failure. Used for single image downloads.
enum ImageResult<T, U> {
    case success(T)
    case failure(U)
}
