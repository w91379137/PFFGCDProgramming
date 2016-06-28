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

class HTTPBinManagerOperation: Operation {
    
    //MARK: - Property
    //Private
    private let semaphore = DispatchSemaphore(value: 0);
    
    //Public
    var delegate : HTTPBinManagerOperationDelegate?
    
    var error : NSError? = nil
    var image : UIImage? = nil
    var getDict : NSDictionary? = nil
    var postDict : NSDictionary? = nil
    
    //MARK:
    override func main() {
        
        WebService.fetchGetResponse { (anyObj, err) in
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.getDict = anyObj! as NSDictionary
            }
            self.semaphore.signal()
        }
        self.semaphore.wait()
        
        if self.isCancelled { return }
        self.delegate?.operationNotice(operation: self)
        
        WebService.postCustomerName("kkbox") { (anyObj, err) in
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.postDict = anyObj! as NSDictionary
            }
            self.semaphore.signal()
        }
        self.semaphore.wait()
        
        if self.isCancelled { return }
        self.delegate?.operationNotice(operation: self)
        
        WebService.fetchImage { (image, err) in
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.image = image
            }
            self.semaphore.signal()
        }
        self.semaphore.wait()
        
        if self.isCancelled { return }
        self.delegate?.operationNotice(operation: self)
    }
    
    override func cancel() {
        super.cancel()
        self.semaphore.signal();
        self.delegate?.operationNotice(operation: self)
    }
    
    func progress() -> Float {
        var progress = Float(0)
        if self.getDict != nil {progress += 0.33}
        if self.postDict != nil {progress += 0.33}
        if self.image != nil {progress += 0.34}
        
        return progress
    }
}

