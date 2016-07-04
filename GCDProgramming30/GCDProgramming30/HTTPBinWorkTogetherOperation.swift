//
//  HTTPBinWorkTogetherOperation.swift
//  GCDProgramming23
//
//  Created by w91379137 on 2016/6/28.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit

class HTTPBinWorkTogetherOperation: Operation, HTTPBinManagerOperationType {

    //MARK: - Property
    //Public
    var delegate : HTTPBinManagerOperationDelegate?
    
    var error : NSError?
    var image : UIImage?
    var getDict : NSDictionary?
    var postDict : NSDictionary?
    
    //MARK:
    override func main() {
        
        let workGroup = DispatchGroup()
        
        workGroup.enter()
        DispatchQueue.global(attributes: .qosDefault).async(group: workGroup) { 
            
        }
        fetchGetResponseWithCallback { (dict, error) in
            if error != nil {
                self.error = error
                self.cancel()
            }
            else {
                self.getDict = dict
            }
            self.delegate?.operationNotice(operation: self)
            workGroup.leave()
        }
        
        workGroup.enter()
        postCustomerName(name: "test") { (dict, error) in
            if error != nil {
                self.error = error
                self.cancel()
            }
            else {
                self.postDict = dict
            }
            self.delegate?.operationNotice(operation: self)
            workGroup.leave()
        }
        
        workGroup.enter()
        fetchImageWithCallback { (image, error) in
            if error != nil {
                self.error = error
                self.cancel()
            }
            else {
                self.image = image
            }
            self.delegate?.operationNotice(operation: self)
            workGroup.leave()
        }
        
        workGroup.notify(queue: .main) {
            self.delegate?.operationNotice(operation: self)
        }
    }
    
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
