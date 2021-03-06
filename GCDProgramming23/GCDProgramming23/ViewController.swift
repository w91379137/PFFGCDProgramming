//
//  ViewController.swift
//  GCDProgramming23
//
//  Created by w91379137 on 2016/6/28.
//  Copyright © 2016年 w91379137. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HTTPBinManagerDelegate {
    
    //MARK: - Property
    
    @IBOutlet var imageView : UIImageView!
    let manager = HTTPBinManager()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.executeOperation()
    }
    
    //MARK: - HTTPBinManagerDelegate
    func operationManagerNotice(binManager: HTTPBinManager!)
    {
        if binManager.cancelled {
            print("取消 取消前進度\(binManager.progress)")
        }
        else {
            print("繼續進行 目前進度\(binManager.progress)")
//            if binManager.progress > 0.2 && !binManager.cancelled {
//                binManager.cancelOperation()
//            }
        }
    }
}

