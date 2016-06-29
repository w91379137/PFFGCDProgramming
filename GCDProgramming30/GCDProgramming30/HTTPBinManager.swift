//
//  HTTPBinManager.swift
//  GCDProgramming23
//
//  Created by w91379137 on 2016/6/28.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit

protocol HTTPBinManagerDelegate {
    func operationManagerNotice(binManager: HTTPBinManager!)
}

class HTTPBinManager: NSObject, HTTPBinManagerOperationDelegate {

    //MARK: - Property
    //Private
    let queue = OperationQueue()
    
    //Public
    var delegate : HTTPBinManagerDelegate?
    
    var error : NSError? = nil
    var progress = Float(0)
    var cancelled = true
    
    //MARK: - Init
    static let sharedInstance = HTTPBinManager()
    
    //MARK:
    func executeOperation() {
        self.queue.cancelAllOperations()
        self.progress = 0
        self.cancelled = false
        
        let op = HTTPBinWorkTogetherOperation()
        op.delegate = self
        self.queue.addOperation(op)
    }
    
    func cancelOperation() {
        self.queue.cancelAllOperations()
    }
    
    //MARK: - HTTPBinManagerOperationDelegate
    func operationNotice<T : HTTPBinManagerOperationType>(operation: T!) {
        self.cancelled = operation.isCancelled
        self.progress = operation.progress()
        self.error = operation.error
        
        self.delegate?.operationManagerNotice(binManager: self)
    }
}
