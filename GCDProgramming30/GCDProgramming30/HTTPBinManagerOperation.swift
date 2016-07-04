//
//  HTTPBinManagerOperation.swift
//  GCDProgramming23
//
//  Created by w91379137 on 2016/6/28.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit

protocol HTTPBinManagerOperationDelegate {
    func operationNotice<T : HTTPBinManagerOperationType>(operation: T!)
}

protocol HTTPBinManagerOperationType {
    
    var isCancelled: Bool { get }
    func progress() -> Float
    var error : NSError? { get }
}

class HTTPBinManagerOperation: Operation,HTTPBinManagerOperationType {
    
    //MARK: - Property
    var delegate : HTTPBinManagerOperationDelegate?
    
    var error : NSError?
    var image : UIImage?
    var getDict : NSDictionary?
    var postDict : NSDictionary?
    
    //MARK:
    override func main() {
        self.loopAllTask()
    }
    
    func loopAllTask() {
        
        if self.isCancelled || (self.error != nil) { return }
        DispatchQueue.main.async() {
            self.delegate?.operationNotice(operation: self);
        }
        
        if self.getDict == nil {
            fetchGetResponseWithCallback { (dict, error) in
                if error != nil {
                    self.error = error
                    self.cancel()
                }
                else {
                    self.getDict = dict
                }
                self.loopAllTask()
            }
        }
        else if self.postDict == nil {
            postCustomerName(name: "test") { (dict, error) in
                if error != nil {
                    self.error = error
                    self.cancel()
                }
                else {
                    self.postDict = dict
                }
                self.loopAllTask()
            }
        }
        else if self.image == nil {
            fetchImageWithCallback { (image, error) in
                if error != nil {
                    self.error = error
                    self.cancel()
                }
                else {
                    self.image = image
                }
                self.loopAllTask()
            }
        }
        else {
            //Finish
        }
    }
    
    //MARK:
    override func cancel() {
        super.cancel()
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


