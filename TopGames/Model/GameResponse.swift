//
//  GameResponse.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit
import ObjectMapper
    
class GameResponse: Mappable {
    
    var total: Int!
    var games: [Game]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        total               <- map["_total"]
        games               <- map["top"]   
    }
    
}
