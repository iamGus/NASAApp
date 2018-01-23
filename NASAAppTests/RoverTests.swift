//
//  RoverTests.swift
//  NASAAppTests
//
//  Created by Angus Muller on 23/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//


// Test parsing of json data into Rover Type

import XCTest
@testable import NASAApp


extension Rover {
    static func validJson() -> [String: Any] {
        
        return [
            "id": 5,
            "name": "Curiosity",
            "landing_date": "2012-08-06",
            "launch_date": "2011-11-26",
            "status": "active",
            "max_sol": 1942,
            "max_date": "2018-01-22",
            "total_photos": 330602,
            "cameras": [
                    [
                        "name": "FHAZ",
                        "full_name": "Front Hazard Avidance Camera"
                    ],
                    [
                        "name": "NAVCAM",
                        "full_name": "Navigation Camera"
                    ]
                ]
        ]
    }
}

class RoverTests: XCTestCase {
    
    let jsonData = Rover.validJson()
    var rover: Rover?
    
    override func setUp() {
        super.setUp()
        rover = nil
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        rover = nil
    }
    
    func testSucsessParse() {
        rover = Rover(json: jsonData, rover: nil)
        XCTAssertNotNil(rover)
    }
    
    func testFailParse() {
        var incorrectJsonData = jsonData
        incorrectJsonData.removeValue(forKey: "name")
        rover = Rover(json: incorrectJsonData, rover: nil)
        XCTAssertNil(rover)
    }
  
    //MARK: Helper
    
    func switchKey<T, U>(_ myDict: inout [T:U], fromKey: T, toKey: T) {
        if let entry = myDict.removeValue(forKey: fromKey) {
            myDict[toKey] = entry
        }
    }
    
}
