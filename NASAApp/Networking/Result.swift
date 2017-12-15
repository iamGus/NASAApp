//
//  Result.swift
//  NASAApp
//
//  Created by Angus Muller on 13/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//


/// Results come through this enum allowing easy switch statement on success or failure.
enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
