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

class HTTPBinWorkTogetherOperation: Operation {

    //MARK: - Property
    //Public
    var delegate : HTTPBinWorkTogetherOperationDelegate?
    
    var error : NSError? = nil
    var image : UIImage? = nil
    var getDict : NSDictionary? = nil
    var postDict : NSDictionary? = nil
    
    //MARK:
    override func main() {
        
        let workGroup = DispatchGroup()
        
        DispatchQueue.global(attributes: .qosUserInteractive).async(group: workGroup) {
            fetchGetResponseWithCallback { (dict, error) in
                if error != nil {
                    self.error = error
                    self.cancel()
                }
                else {
                    self.getDict = dict
                }
                self.delegate?.operationWorkTogetherNotice(operation: self)
            }
        }
        
        DispatchQueue.global(attributes: .qosUserInteractive).async(group: workGroup) {
            postCustomerName(name: "test") { (dict, error) in
                if error != nil {
                    self.error = error
                    self.cancel()
                }
                else {
                    self.postDict = dict
                }
                self.delegate?.operationWorkTogetherNotice(operation: self)
            }
        }
        
        DispatchQueue.global(attributes: .qosUserInteractive).async(group: workGroup) {
            fetchImageWithCallback { (image, error) in
                if error != nil {
                    self.error = error
                    self.cancel()
                }
                else {
                    self.image = image
                }
                self.delegate?.operationWorkTogetherNotice(operation: self)
            }
        }
        
        workGroup.notify(queue: .main) {
            self.delegate?.operationWorkTogetherNotice(operation: self)
        }
    }
    
    override func cancel() {
        super.cancel()
        self.delegate?.operationWorkTogetherNotice(operation: self)
    }
    
    func progress() -> Float {
        var progress = Float(0)
        if self.getDict != nil {progress += 0.33}
        if self.postDict != nil {progress += 0.33}
        if self.image != nil {progress += 0.34}
        
        return progress
    }
}
