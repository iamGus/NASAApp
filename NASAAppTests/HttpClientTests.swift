//
//  HttpClientTests.swift
//  NASAAppTests
//
//  Created by Angus Muller on 22/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

// Testing end points for Rover and Mars photos can be reached and data is returned

import XCTest
@testable import NASAApp

class HttpClientTests: XCTestCase {
    
    var httpClient = NASAClient()
    
    override func setUp() {
        super.setUp()
        httpClient = NASAClient()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        httpClient = NASAClient()
    }
    
    // Can get Rover data returned from Nasa api
    func testMarsRoverDownload() {
        var expect: XCTestExpectation? = expectation(description: "multiEx")
        
        httpClient.getRovers() { result in
            switch result {
            case .success(let data): XCTAssertNotNil(data, "No data is being downloaded")
                expect?.fulfill()
                expect = nil
            case .failure(let error): XCTFail(error.localizedDescription)
                expect?.fulfill()
                expect = nil
            }
            
        }
        self.waitForExpectations(timeout: 3) { (error) in
            guard error == nil else {
                XCTAssert(false)
                NSLog("Timeout Error")
                return
            }
        }
    }
    
    // Can get mars phtos returned from nasa api
    func testMarsPhotosDownload() {
        var expect: XCTestExpectation? = expectation(description: "multiEx")
        
        httpClient.getRovers() { [weak self] result in
            switch result {
            case .success(let data):
                self?.httpClient.getPhotosAll(rovers: data, completion: { results in
                    switch results {
                    case .success(let data): XCTAssertNotNil(data, "No data is being downloaded")
                        expect?.fulfill()
                        expect = nil
                    case .failure(let error): XCTFail(error.localizedDescription)
                        expect?.fulfill()
                        expect = nil
                    }
                })
                expect?.fulfill()
                expect = nil
            case .failure(let error): XCTFail(error.localizedDescription)
                expect?.fulfill()
                expect = nil
            }
            
        }
        self.waitForExpectations(timeout: 3) { (error) in
            guard error == nil else {
                XCTAssert(false)
                NSLog("Timeout Error")
                return
            }
        }
        
    }
    
    
}
