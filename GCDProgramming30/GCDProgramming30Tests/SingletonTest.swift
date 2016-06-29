//
//  SingletonTest.swift
//  GCDProgramming30
//
//  Created by w91379137 on 2016/6/29.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit
import XCTest

class SingletonTest: XCTestCase {
    
    func testSingletonSharedInstanceCreated() {
        XCTAssertNotNil(HTTPBinManager.sharedInstance)
    }
    
    func testSingletonUniqueInstanceCreated() {
        XCTAssertNotNil(HTTPBinManager())
    }
    
    func testSingletonReturnsSameSharedInstanceTwice() {
        let s1 = HTTPBinManager.sharedInstance
        XCTAssertEqual(s1, HTTPBinManager.sharedInstance)
    }
    
    func testSingletonSharedInstanceSeparateFromUniqueInstance() {
        let s1 = HTTPBinManager.sharedInstance
        XCTAssertNotEqual(s1, HTTPBinManager())
    }
    
    func testSingletonReturnsSeparateUniqueInstances() {
        let s1 = HTTPBinManager()
        XCTAssertNotEqual(s1, HTTPBinManager())
    }
}
