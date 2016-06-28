//
//  API.swift
//  GCDProgramming23
//
//  Created by w91379137 on 2016/6/28.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit

func fetchGetResponseWithCallback(completion: ((dict: [String : AnyObject]?, error: NSError?) -> ())) {
    
    guard let url = NSURL(string: "http://httpbin.org/get") else {
        let error =
            NSError(domain: "Invalid URL",
                    code: -1,
                    userInfo: ["description" : "Invalid URL"])
        completion(dict: nil, error: error)
        return
    }
    
    let request = NSURLRequest(URL: url)
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
        
        dispatch_async(dispatch_get_main_queue(), { 
            
            if error != nil {
                completion(dict: nil, error: error)
            }
            else {
                
                var dict : [String : AnyObject]? = nil
                var jsonError : NSError? = nil
                
                do {
                    dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject]
                }
                catch {
                    jsonError =
                        NSError(domain: "NSJSONSerialization.JSONObjectWithData",
                                code: -1,
                                userInfo: ["description" : "\(error)"])
                }
                
                completion(dict: dict, error: jsonError)
            }
        })
    }
    
    task.resume()
}

func postCustomerName(name : String!, completion: ((dict: [String : AnyObject]?, error: NSError?) -> ())) {
    
    guard let url = NSURL(string: "http://httpbin.org/post") else {
        let error =
            NSError(domain: "Invalid URL",
                    code: -1,
                    userInfo: ["description" : "Invalid URL"])
        completion(dict: nil, error: error)
        return
    }
    
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["custname" : name], options: NSJSONWritingOptions.init(rawValue: 0))
    }
    catch {
        let jsonError =
            NSError(domain: "NSJSONSerialization.JSONObjectWithData",
                    code: -1,
                    userInfo: ["description" : "\(error)"])
        
        completion(dict: nil, error: jsonError)
        return
    }
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
        
        if error != nil {
            completion(dict: nil, error: error)
        }
        else {
            var dict : [String : AnyObject]? = nil
            var jsonError : NSError? = nil
            
            do {
                dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject]
            }
            catch {
                jsonError =
                    NSError(domain: "NSJSONSerialization.JSONObjectWithData",
                            code: -1,
                            userInfo: ["description" : "\(error)"])
            }
            
            completion(dict: dict, error: jsonError)
        }
    }
    
    task.resume()
}

func fetchImageWithCallback(completion: ((image: UIImage?, error: NSError?) -> ())) {
    
    guard let url = NSURL(string: "http://httpbin.org/image/png") else {
        let error =
            NSError(domain: "Invalid URL",
                    code: -1,
                    userInfo: ["description" : "Invalid URL"])
        completion(image: nil, error: error)
        return
    }
    
    let request = NSURLRequest(URL: url)
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if error != nil {
                completion(image: nil, error: error)
            }
            else {
                
                if let image = UIImage.init(data: data!) {
                    completion(image: image, error: nil)
                }
                else {
                    let error =
                        NSError(domain: "Invalid data",
                            code: -1,
                            userInfo: ["description" : "Invalid data"])
                    
                    completion(image: nil, error: error)
                }
            }
        })
    }
    
    task.resume()
}


