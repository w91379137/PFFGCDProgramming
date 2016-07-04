//
//  HTTPBinWorkTogetherOperationTests.swift
//  GCDProgramming30
//
//  Created by w91379137 on 2016/7/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import XCTest

class HTTPBinWorkTogetherOperationTests: XCTestCase, HTTPBinManagerOperationDelegate {
    
    //查查 Generic block
    var delegateBlock : ((operation: HTTPBinManagerOperation) -> ())?
    
    func testFailAtStep1() {
        
        let expectation = self.expectation(withDescription: "testFailAtStep1")
        
        let op = HTTPBinManagerOperation()
        op.delegate = self
        
        self.delegateBlock = { (operation) in
            
            XCTAssertTrue(self.isCorrectOperationProgress(operation: operation));
            
            if operation.isCancelled || (operation.progress() == 1) {
                XCTAssertTrue(operation.isCancelled)
                expectation.fulfill()
                self.delegateBlock = nil
            }
        }
        
        op.main()
        if !op.isCancelled {op.cancel()}
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }
    
    func testFailAtStep2() {
        
        let expectation = self.expectation(withDescription: "testFailAtStep2")
        
        let op = HTTPBinManagerOperation()
        op.delegate = self
        
        self.delegateBlock = { (operation) in
            
            XCTAssertTrue(self.isCorrectOperationProgress(operation: operation));
            
            if operation.isCancelled || (operation.progress() == 1) {
                XCTAssertTrue(operation.isCancelled)
                expectation.fulfill()
                self.delegateBlock = nil
            }
            
            if !op.isCancelled && (op.progress() > 0.3) {op.cancel()}
        }
        
        op.main()
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }
    
    func testFailAtStep3() {
        
        let expectation = self.expectation(withDescription: "testFailAtStep3")
        
        let op = HTTPBinManagerOperation()
        op.delegate = self
        
        self.delegateBlock = { (operation) in
            
            XCTAssertTrue(self.isCorrectOperationProgress(operation: operation));
            
            if operation.isCancelled || (operation.progress() == 1) {
                XCTAssertTrue(operation.isCancelled)
                expectation.fulfill()
                self.delegateBlock = nil
            }
            
            if !op.isCancelled && (op.progress() > 0.6) {op.cancel()}
        }
        
        op.main()
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }
    
    func testPassAllStep() {
        
        let expectation = self.expectation(withDescription: "testPassAllStep")
        
        let op = HTTPBinManagerOperation()
        op.delegate = self
        
        self.delegateBlock = { (operation) in
            
            XCTAssertTrue(self.isCorrectOperationProgress(operation: operation));
            
            if operation.isCancelled || (operation.progress() == 1) {
                XCTAssertFalse(operation.isCancelled)
                expectation.fulfill()
                self.delegateBlock = nil
            }
        }
        
        op.main()
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }
    
    func isCorrectOperationProgress(operation : HTTPBinManagerOperation) -> Bool {
        var progress = Float(0)
        if (operation.getDict != nil) { progress += 0.33 }
        if (operation.postDict != nil) { progress += 0.33 }
        if (operation.image != nil) { progress += 0.34 }
        return operation.progress() == progress;
    }
    
    //MARK: - HTTPBinManagerOperationDelegate
    func operationNotice<T : HTTPBinManagerOperationType>(operation: T!) {
        if let op = operation as? HTTPBinManagerOperation, let block = delegateBlock{
            block(operation: op)
        }
    }
}
