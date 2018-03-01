//
//  DatabaseHelperTest.swift
//  TopGamesTests
//
//  Created by Arthur Junqueira Cançado on 29/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit
import Quick
import Nimble
import ObjectMapper
import CoreData

@testable import TopGames

class DatabaseHelperTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var gameResponse: GameResponse!
        
        beforeEach {
            
            let json = self.getContentJson()
            
            gameResponse = Mapper<GameResponse>().map(JSON: json)
            
            let managedObjectContext = self.setUpInMemoryManagedObjectContext()
            
            DatabaseHelper.shared.changeContext(managedObjectContext)
        }
        
        describe("Persistencia dos games"){
            
            context("Apos consumir o serviço e ter os games parseados em um objeto, efetuar operações no banco de dados"){
                
                it("Validar primeira vez que consulta os games salvos...tem de ser zero"){

                    let games = DatabaseHelper.shared.getAllGames()
                    
                    expect(games.count).to(equal(0))
                }
                
                it("Após inserir tem de ter mais de um !"){
                    
                    let game = gameResponse.games.first
                    
                    DatabaseHelper.shared.saveGame(game!)
                    
                    let games = DatabaseHelper.shared.getAllGames()
                    
                    expect(games.count).to(beGreaterThan(0))
                }
                
                it("Insere e remove tem de dar zero") {
                    
                    let game = gameResponse.games.first
                        
                    DatabaseHelper.shared.saveGame(game!)
                    
                    var games = DatabaseHelper.shared.getAllGames()
                    
                    expect(games.count).to(beGreaterThan(0))
                    
                    for game in gameResponse.games {
                        
                        DatabaseHelper.shared.deleteGame(game)
                    }
                    
                    games = DatabaseHelper.shared.getAllGames()
                    
                    expect(games.count).to(equal(0))
                }
                
                it("Insere varios games e remove todos de uma vez") {
                    
                    for game in gameResponse.games {
                        
                        // Salva 5 vezes o mesmo game
                        DatabaseHelper.shared.saveGame(game)
                        DatabaseHelper.shared.saveGame(game)
                        DatabaseHelper.shared.saveGame(game)
                        DatabaseHelper.shared.saveGame(game)
                        DatabaseHelper.shared.saveGame(game)
                    }
                    
                    var games = DatabaseHelper.shared.getAllGames()
                    
                    expect(games.count).to(equal(5))
                    
                    DatabaseHelper.shared.deleteAllGames()
                    
                    games = DatabaseHelper.shared.getAllGames()
                    
                    expect(games.count).to(equal(0))
                    
                }
                
                it("Verificar se tem o game especifico salvo") {
                    
                    let game = gameResponse.games.first
                    
                    DatabaseHelper.shared.saveGame(game!)
                    
                    let games = DatabaseHelper.shared.getAllGames()
                    
                    expect(games.count).to(equal(1))
                    
                    let containGame = DatabaseHelper.shared.containsGame(game!)
                    
                    expect(containGame).to(beTrue())
                }
            }
        }
    }
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
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
