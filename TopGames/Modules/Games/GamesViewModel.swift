//
//  GamesViewModel.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit

class GamesViewModel {
    
    let gameService = GamesService()
    
    let showLoadingHud: Bindable = Bindable(false)
    
    let showErrorAlert: Bindable = Bindable(false)
    
    var games: [Game] = []

    var limit: Int = 20
    
    func fetchGames(completion: @escaping ()->()) {
        
        var params: JSON = [:]
        
        params["offset"] = 0
        params["limit"] = 100
        
        showLoadingHud.value = true
        
        gameService.fetchGames(with: params, completion: { [weak self] result, error in
            
            self?.showLoadingHud.value = false
            
            if let gamesResult = result {
                
                DatabaseHelper.shared.deleteAllGames()
                
                DatabaseHelper.shared.saveGames(gamesResult.games)
                
            } else if let _ = error {
                
                self?.showErrorAlert.value = true
            }
            
            completion()
        })
    }
    
    func getLimitedGames() {
        games = DatabaseHelper.shared.getLimitedGames(limit)
    }
    
    func restartLimit() {
        limit = 20
    }
    
    func numberOfItemsInSection(section: Int) -> Int{
        return games.count
    }
    
    func getGame(at indexPath: IndexPath) -> Game {
        return games[indexPath.row]
    }
}


