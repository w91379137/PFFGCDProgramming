//
//  API.swift
//  GCDProgramming23
//
//  Created by w91379137 on 2016/6/28.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit

func fetchGetResponseWithCallback(completion: ((dict: [String : AnyObject]?, error: NSError?) -> ())) {
    
    guard let url = URL(string: "http://httpbin.org/get") else {
        let error =
            NSError(domain: "Invalid URL",
                    code: -1,
                    userInfo: ["description" : "Invalid URL"])
        completion(dict: nil, error: error)
        return
    }
    
    let task = URLSession.shared().dataTask(with: url) { (data, response, error) in
        DispatchQueue.main.async(execute: { 
            if error != nil {
                completion(dict: nil, error: error)
            }
            else {
                
                var dict : [String : AnyObject]? = nil
                var jsonError : NSError? = nil
                
                do {
                    dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
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
    
    guard let url = URL(string: "http://httpbin.org/post") else {
        let error =
            NSError(domain: "Invalid URL",
                    code: -1,
                    userInfo: ["description" : "Invalid URL"])
        completion(dict: nil, error: error)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: ["custname" : name], options: JSONSerialization.WritingOptions.init(rawValue: 0))
    }
    catch {
        let jsonError =
            NSError(domain: "NSJSONSerialization.JSONObjectWithData",
                    code: -1,
                    userInfo: ["description" : "\(error)"])
        
        completion(dict: nil, error: jsonError)
        return
    }
    
    let task = URLSession.shared().dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async(execute: {
            if error != nil {
                completion(dict: nil, error: error)
            }
            else {
                var dict : [String : AnyObject]? = nil
                var jsonError : NSError? = nil
                
                do {
                    dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
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

func fetchImageWithCallback(completion: ((image: UIImage?, error: NSError?) -> ())) {
    
    guard let url = URL(string: "http://httpbin.org/image/png") else {
        let error =
            NSError(domain: "Invalid URL",
                    code: -1,
                    userInfo: ["description" : "Invalid URL"])
        completion(image: nil, error: error)
        return
    }
    
    let task = URLSession.shared().dataTask(with: url) { (data, response, error) in
        DispatchQueue.main.async(execute: {
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


