//
//  GamesService.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import Alamofire
import ObjectMapper

class GamesService {
    
    func fetchGames(with params: JSON, completion: @escaping (_ gameResponse: GameResponse?, _ error: Error?) -> ()) {
        
        Alamofire.request(GameRouter.GetGamesTop(params))
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(let json):
                    
                    let gameResponse = Mapper<GameResponse>().map(JSON: json as! JSON)
                    
                    completion(gameResponse, nil)
                    
                case .failure(let error):
                    
                    completion(nil,error)
                }
        }
    }
    
}
