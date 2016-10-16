//
//  FunctionsDB.swift
//  MasterDetailView
//
//  Created by Daniel Hauagge on 9/29/16.
//  Copyright © 2016 CS2048 Instructor. All rights reserved.
//

import Foundation
import UIKit

class FunctionsDB {
    static var sharedInstance = FunctionsDB()
    
    var functions:[String] = [] {
        didSet {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName("functionDBChanged", object: self)
        }
    }
    
    var thumbnail:[UIImage] = [] {
        didSet {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName("functionDBChanged", object: self)
        }
    }
    
}
