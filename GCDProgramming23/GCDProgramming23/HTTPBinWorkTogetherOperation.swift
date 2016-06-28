//
//  HTTPBinWorkTogetherOperation.swift
//  GCDProgramming23
//
//  Created by w91379137 on 2016/6/28.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit

protocol HTTPBinWorkTogetherOperationDelegate {
    func operationWorkTogetherNotice(operation: HTTPBinWorkTogetherOperation!)
}

class HTTPBinWorkTogetherOperation: NSOperation {

    //MARK: - Property
    //Public
    var delegate : HTTPBinWorkTogetherOperationDelegate?
    
    var error : NSError? = nil
    var image : UIImage? = nil
    var getDict : NSDictionary? = nil
    var postDict : NSDictionary? = nil
    
    //MARK:
    override func main() {
        
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        fetchGetResponseWithCallback { (anyObj, err) in
            
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.getDict = anyObj
            }
            self.delegate?.operationWorkTogetherNotice(self)
            dispatch_group_leave(group)
        }
        
        dispatch_group_enter(group)
        postCustomerName("test") { (anyObj, err) in
            
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.postDict = anyObj
            }
            self.delegate?.operationWorkTogetherNotice(self)
            dispatch_group_leave(group)
        }
        
        dispatch_group_enter(group)
        fetchImageWithCallback { (image, err) in
            
            if err != nil {
                self.error = err
                self.cancel()
            }
            else {
                self.image = image
            }
            self.delegate?.operationWorkTogetherNotice(self)
            dispatch_group_leave(group)
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            self.delegate?.operationWorkTogetherNotice(self)
        }
    }
    
    override func cancel() {
        super.cancel()
        self.delegate?.operationWorkTogetherNotice(self)
    }
    
    func progress() -> Float {
        var progress = Float(0)
        if self.getDict != nil {progress += 0.33}
        if self.postDict != nil {progress += 0.33}
        if self.image != nil {progress += 0.34}
        
        return progress
    }
}
