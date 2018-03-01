//
//  GameDetailViewModel.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit

class GameDetailViewModel {
    
    var game: Game!
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfItemsInSection(section: Int) -> Int{
        
        if section == 1 {
            return 2
        }
        
        return 1
    }
    
    func heightOfItemsInSection(at indexPath :IndexPath) -> CGFloat{
        
        if indexPath.section == 0 {
            return 250
        }
        
        return 44
    }
    
    func getBoxWith(width: CGFloat, andHeight height: CGFloat) -> String {
        
        return game.getBoxWith(width: width, andHeight: height)
    }
}
