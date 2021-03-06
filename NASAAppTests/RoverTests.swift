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

// Test json data
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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        
        rover = Rover(json: jsonData, rover: nil)
        XCTAssertNotNil(rover)
        
        XCTAssertEqual(rover?.id, 5)
        XCTAssertEqual(rover?.name, "Curiosity")
        XCTAssertEqual(rover?.landingDate, formatter.date(from: "2012-08-06"))
        XCTAssertEqual(rover?.launchDate, formatter.date(from: "2011-11-26"))
        XCTAssertEqual(rover?.status, "active")
        XCTAssertEqual(rover?.maxSol, 1942)
        XCTAssertEqual(rover?.maxDate, formatter.date(from: "2018-01-22"))
        XCTAssertEqual(rover?.totalPhotos, 330602)
        XCTAssertEqual(rover?.cameras.count, 2)
    }
    
    func testFailParse() {
        var incorrectJsonData = jsonData
        incorrectJsonData.removeValue(forKey: "name")
        rover = Rover(json: incorrectJsonData, rover: nil)
        XCTAssertNil(rover)
    }
  
 
    
}
