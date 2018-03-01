//
//  Environment.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
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
