//
//  HTTPBinManagerTests.swift
//  GCDProgramming30
//
//  Created by w91379137 on 2016/7/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import XCTest

class HTTPBinManagerTests: XCTestCase, HTTPBinManagerDelegate {
    
    var delegateBlock : ((binManager: HTTPBinManager) -> ())?
    
    func testSingleton() {
        
        let expectation = self.expectation(withDescription: "testSingleton")
        
        let group = DispatchGroup()
        
        var s1 : HTTPBinManager? = nil
        
        group.enter()
        DispatchQueue.global(attributes: .qosUserInitiated).async { 
            s1 = HTTPBinManager.sharedInstance
            group.leave()
        }
        
        var testTimes = 0
        repeat {
            
            group.enter()
            DispatchQueue.global(attributes: .qosDefault).async {
                if s1 != nil { XCTAssertEqual(s1, HTTPBinManager.sharedInstance) }
                group.leave()
            }
            testTimes += 1;
        } while testTimes < 100
        
        group.notify(queue: DispatchQueue.main) { 
            expectation.fulfill()
        }
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }
    
    //HTTPBinManager 要加入一個叫做 executeOperation 的 method，這個 method 首先會清除 operation queue 裡頭所有的 operation，然後加入新的 HTTPBinManagerOperation。
    func testExecuteOperation() {
        let manager = HTTPBinManager.sharedInstance
        manager.executeOperation()
        XCTAssertEqual(manager.queue.operationCount, 1)
        manager.cancelOperation()
    }
    
    //HTTPBinManagerOperation 的 delegate 是 HTTPBinManager。 HTTPBinManager 也有自己的 delegate，在 HTTPBinManagerOperation 成功抓取資料、發生錯誤的時候，HTTPBinManager 也會將這些事情告訴自己的 delegate。
    func testManagerDelegateFail() {
        
        let expectation = self.expectation(withDescription: "testManagerDelegateFail")
        
        let manager = HTTPBinManager.sharedInstance
        manager.delegate = self
        
        let op = HTTPBinManagerOperation()
        op.delegate = manager
        
        self.delegateBlock = { (binManager) in
            
            if binManager.cancelled || (binManager.progress == 1) {
                
                XCTAssertTrue(binManager.cancelled)
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
    
    func testManagerDelegateSuccess() {
        
        let expectation = self.expectation(withDescription: "testManagerDelegateSuccess")
        
        let manager = HTTPBinManager.sharedInstance
        manager.delegate = self
        
        let op = HTTPBinManagerOperation()
        op.delegate = manager
        
        self.delegateBlock = { (binManager) in
            
            if binManager.cancelled || (binManager.progress == 1) {
                
                XCTAssertFalse(binManager.cancelled)
                expectation.fulfill()
                self.delegateBlock = nil
            }
        }
        
        op.main()
        
        self.waitForExpectations(withTimeout: 5.0) { (error) in
            print(error)
        }
    }
    
    //MARK: - HTTPBinManagerDelegate
    func operationManagerNotice(binManager: HTTPBinManager!) {
        if let block = delegateBlock {
            block(binManager:binManager)
        }
    }
}
