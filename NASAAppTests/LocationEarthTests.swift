//
//  LocationEarthTests.swift
//  NASAAppTests
//
//  Created by Angus Muller on 23/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

import XCTest
@testable import NASAApp

class LocationEarthTests: XCTestCase {
    
    
    var locationClient = LocationSearchClient()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Get correct Long and Lat from test search term
    func testGetCorrectLocationDara() {
        var expect: XCTestExpectation? = expectation(description: "multiEx")
        
        locationClient.search(withTerm: "London") { (mapItem, error) in
            let coordinates = mapItem[0].placemark.coordinate
            XCTAssertEqual(coordinates.latitude, 51.500152399999997)
            XCTAssertEqual(coordinates.longitude, -0.12623619999999999)
            expect?.fulfill()
            expect = nil
        }
        self.waitForExpectations(timeout: 3) { (error) in
            guard error == nil else {
                XCTAssert(false)
                NSLog("Timeout Error")
                return
            }
        }
    }
    
    // Test downlaod and return of UIImage form given url
    func testDownloadImage() {
        let imageClient = SinglePhotoDownloader()
        var expect: XCTestExpectation? = expectation(description: "multiEx")
        
        let testImageUrl = URL(string: "https://earthengine.googleapis.com/api/thumb?thumbid=6edd4b7212ffe615b0a95612621eb640&token=8771dfa3155f21e0721fc954ccae4a9d")
        
        imageClient.downloadImage(url: testImageUrl!) { (results) in
            switch results {
            case .success(let image):
                XCTAssertNotNil(image, "Problem loading image")
                expect?.fulfill()
                expect = nil
            case .failure(let error):
                XCTFail(error)
                expect?.fulfill()
                expect = nil
            }
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            guard error == nil else {
                XCTAssert(false)
                NSLog("Timeout Error")
                return
            }
        }
    }
    
    
}
