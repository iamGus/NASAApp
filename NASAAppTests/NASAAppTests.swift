//
//  NASAAppTests.swift
//  NASAAppTests
//
//  Created by Angus Muller on 12/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import XCTest
@testable import NASAApp

class NASAAppTests: XCTestCase {
    
    var nasaClient: NASAClient!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        nasaClient = NASAClient()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
