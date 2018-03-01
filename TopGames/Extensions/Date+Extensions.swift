//
//  Date+Extensions.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 01/03/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit

extension Date {
    
    func toStringWithFormat(_ format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self).uppercased()
    }
    
}
