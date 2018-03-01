//
//  Environment.swift
//  VivaChallenge
//
//  Created by Arthur Junqueira Cançado on 23/03/17.
//  Copyright © 2017 Arthur Cancado. All rights reserved.
//

import UIKit

enum Environment: Int {
    case development
    case production
}

extension Environment {
    
    static var current: Environment {
        
        get {
            return Environment(rawValue: UserDefaults.standard.integer(forKey: Constants.SessionKeys.environment))!
        }
        set (val) {
            UserDefaults.standard.set(val.hashValue, forKey: Constants.SessionKeys.environment)
        }
    }
}   
