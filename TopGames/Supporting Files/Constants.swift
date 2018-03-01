//
//  Constants.swift
//  VivaChallenge
//
//  Created by Arthur Junqueira Cançado on 23/03/17.
//  Copyright © 2017 Arthur Cancado. All rights reserved.
//

import UIKit

typealias JSON = Dictionary<String, Any>

struct Constants {
    
    struct API {
        static var baseURL: String {
            switch Environment.current {
            case .development:
                return "https://api.twitch.tv/"
            case .production:
                return "https://api.twitch.tv/"
            }
        }
    }
    
    struct SessionKeys {
        
        static let environment = "environment"
    }
    
    struct SegueIds {
        
        static let segueToGameDetail = "segueToGameDetail"
    }
    
    struct CellIds{
        
        static let defaultCellId = "CellID"
        static let imageCellId = "ImageCellID"
    }
    
    struct Messages {
        
        static let empty = ""
        
        static let ok = "Ok"
        
        static let cancel = "Cancel"
        
        static let pullToRefresh = "Pull to refresh"
        
        static let gamesTitle = "** Top 100 games on Twitch **"
    
        static let defaultTile = "TopGames"
        
        static let youAreOffline = "You are offline. The data presented is the last time we synchronized the database."
    }
    
    struct formatts {
        
        static let us = "yyyy-MM-dd HH:mm:ss"
        static let pt = "dd/MM/yyyy HH:mm:ss"
        
    }
    
    struct ServerKeys{
        
        static let clientId = "prk3j0313bpwh961ga9dx4h3wf4mdc"
    }
    
}

extension Notification.Name {
    static let saveGames = Notification.Name("save_games")
}
