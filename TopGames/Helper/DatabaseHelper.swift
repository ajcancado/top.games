//
//  DatabaseHelper.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit
import CoreData

struct ParamsName {
    
    static let entityGames = "Games"
    static let entityUpdates = "Updates"
    
    static let name = "name"
    static let logo = "logo"
    static let box = "box"
    static let viewers = "viewers"
    static let channels = "channels"
    
    static let updateDate = "updateDate"
}

class DatabaseHelper {
    
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    
    static let shared = DatabaseHelper()
    
    private init() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        managedContext = appDelegate.managedObjectContext
    }
    
    func changeContext(_ context: NSManagedObjectContext) {
        
        managedContext = context
    }
    
    func saveGames(_ games: [Game]){
        
        for game in games{
            
            saveGame(game)
        }
        
        saveUpdateDate()
    }
    
    func saveGame(_ game: Game){
        
        let entity = NSEntityDescription.entity(forEntityName: ParamsName.entityGames, in: managedContext)!
        
        let gameToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        gameToSave.setValue(game.name, forKeyPath: ParamsName.name)
        gameToSave.setValue(game.logo, forKeyPath: ParamsName.logo)
        gameToSave.setValue(game.box, forKeyPath: ParamsName.box)
        gameToSave.setValue(game.viewers, forKeyPath: ParamsName.viewers)
        gameToSave.setValue(game.channels, forKeyPath: ParamsName.channels)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveUpdateDate() {
        
        let entity = NSEntityDescription.entity(forEntityName: ParamsName.entityUpdates, in: managedContext)!
        
        let update = NSManagedObject(entity: entity, insertInto: managedContext)
        
        update.setValue(Date().toStringWithFormat(Constants.formatts.pt), forKeyPath: ParamsName.updateDate)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func getLastUpdateDate() -> String? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ParamsName.entityUpdates)
        
        var result: [NSManagedObject] = []
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if result.count > 0 {
            return result.last?.value(forKey: ParamsName.updateDate) as? String
        }
        
        return nil
    }
    
    func deleteGame(_ game: Game) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ParamsName.entityGames)
        
        let predicate = NSPredicate(format: "name = %@", game.name)
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        var result: [NSManagedObject] = []
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        managedContext.delete(result.first!)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteAllGames(){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ParamsName.entityGames)
        
        var result: [NSManagedObject] = []
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for r in result {
            managedContext.delete(r)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }

    func getAllGames() -> [Game] {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ParamsName.entityGames)
        
        var result: [NSManagedObject] = []
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        var games: [Game] = []
        
        for r in result {
            
            let game = Game()
            
            game.name = r.value(forKeyPath: ParamsName.name) as? String
            game.box = r.value(forKeyPath: ParamsName.box) as? String
            game.logo = r.value(forKeyPath: ParamsName.logo) as? String
            game.viewers = r.value(forKeyPath: ParamsName.viewers) as? Int
            game.channels = r.value(forKeyPath: ParamsName.channels) as? Int
            
            games.append(game)
        }
        
        return games
    }
    
    func getLimitedGames(_ limit: Int) -> [Game] {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ParamsName.entityGames)
        
        fetchRequest.fetchLimit = limit
        
        var result: [NSManagedObject] = []
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        var games: [Game] = []
        
        for r in result {
            
            let game = Game()
            
            game.name = r.value(forKeyPath: ParamsName.name) as? String
            game.box = r.value(forKeyPath: ParamsName.box) as? String
            game.logo = r.value(forKeyPath: ParamsName.logo) as? String
            game.viewers = r.value(forKeyPath: ParamsName.viewers) as? Int
            game.channels = r.value(forKeyPath: ParamsName.channels) as? Int
            
            games.append(game)
        }
        
        return games
    }
    
    func containsGame(_ game: Game) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ParamsName.entityGames)
        
        let predicate = NSPredicate(format: "name = %@", game.name)
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        var result: [NSManagedObject] = []
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return result.count > 0 ? true : false
    }
}
