//
//  APITest.swift
//  GCDProgramming30
//
//  Created by w91379137 on 2016/6/29.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit
import XCTest

class APITest: XCTestCase {
    
    func testGet() {
        
        let expectation = self.expectation(withDescription: "testGet")
        fetchGetResponseWithCallback { (dict, error) in
            
            XCTAssertNotNil(dict, "dict should not be nil")
            XCTAssertNil(error, "err should be nil")
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }
    
    func testPost() {
        
        let expectation = self.expectation(withDescription: "testPost")
        postCustomerName(name: "test") { (dict, error) in
            
            XCTAssertNotNil(dict, "dict should not be nil")
            XCTAssertNil(error, "err should be nil")
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }
    
    func testImage() {
        
        let expectation = self.expectation(withDescription: "testImage")
        
        fetchImageWithCallback { (image, error) in
            
            XCTAssertNotNil(image, "image should not be nil")
            XCTAssertNil(error, "err should be nil")
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }

}
