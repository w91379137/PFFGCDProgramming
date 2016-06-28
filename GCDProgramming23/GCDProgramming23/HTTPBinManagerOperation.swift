//
//  HTTPBinManagerOperation.swift
//  GCDProgramming23
//
//  Created by w91379137 on 2016/6/28.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit

protocol HTTPBinManagerOperationDelegate {
    func operationNotice(operation: HTTPBinManagerOperation!)
}

class HTTPBinManagerOperation: NSOperation {
    
    //MARK: - Property
    //Private
    private let semaphore = dispatch_semaphore_create(0);
    
    //Public
    var delegate : HTTPBinManagerOperationDelegate?
    
    var error : NSError? = nil
    var image : UIImage? = nil
    var getDict : NSDictionary? = nil
    var postDict : NSDictionary? = nil
    
    //MARK:
    override func main() {
        
        fetchGetResponseWithCallback { (anyObj, err) in
            
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.getDict = anyObj
            }
            
            dispatch_semaphore_signal(self.semaphore)
        }
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
        
        if self.cancelled { return }
        self.delegate?.operationNotice(self)
        
        postCustomerName("test") { (anyObj, err) in
            
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.postDict = anyObj
            }
            
            dispatch_semaphore_signal(self.semaphore)
        }
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
        
        if self.cancelled { return }
        self.delegate?.operationNotice(self)
        
        fetchImageWithCallback { (image, err) in
            
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.image = image
            }
            
            dispatch_semaphore_signal(self.semaphore)
        }
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
        
        if self.cancelled { return }
        self.delegate?.operationNotice(self)
    }
    
    override func cancel() {
        super.cancel()
        dispatch_semaphore_signal(self.semaphore);
        self.delegate?.operationNotice(self)
    }
    
    func progress() -> Float {
        var progress = Float(0)
        if self.getDict != nil {progress += 0.33}
        if self.postDict != nil {progress += 0.33}
        if self.image != nil {progress += 0.34}
        
        return progress
    }
}


