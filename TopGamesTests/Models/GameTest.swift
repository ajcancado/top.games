//
//  GameTest.swift
//  TopGamesTests
//
//  Created by Arthur Junqueira Cançado on 29/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit
import Quick
import Nimble
import ObjectMapper

@testable import TopGames

class GameTest: QuickSpec {

    override func spec() {
        super.spec()
        
        var gameResponse: GameResponse!
        
        beforeEach {
        
            let json = self.getContentJson()
            
            gameResponse = Mapper<GameResponse>().map(JSON: json)
        }
        
        describe("Parse do JSON"){
            
            context("Quando realizamos o parse do json"){
                
                it("O objeto não pode ser nulo"){
                    
                    expect(gameResponse).toNot(beNil())
                }
                
                it("O total deve bater com o retorno"){
                    
                    expect(gameResponse.total).to(equal(1157))
                }
                
                it("A quantidade de jogos deve ser maior que zero caso tenha retornado com sucesso"){
                    
                    expect(gameResponse.games.count).to(beGreaterThan(0))
                }
                
                it("A quantidade de jogos deve bater com o retorno"){
                    
                    expect(gameResponse.games.count).to(equal(1))
                }
            }
        }
        
    }
    
    func getContentJson() -> [String: Any] {
        
        do {
            
            let bundle = Bundle(for: type(of: self))
            
            if let file = bundle.url(forResource: "content", withExtension: "json") {
                
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let object = json as? [String: Any] {
                    return object
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return [:]
    }
    
    public func testDummy() {}
    
    
}
