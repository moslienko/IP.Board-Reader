//
//  FavoriteThemes.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 17/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
 Получить избранные темы форума
 - Parameter id: ID родительского форума
 - Returns: Темы
 */
func getFavoriteThemesForForum(id:String) -> [FavoriteTheme]{
    var themes = [FavoriteTheme]()
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return themes }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "FavoriteThemes")
    fetchRequest.predicate = NSPredicate(format: "forumID = %@", id)
    let sort = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sort]
    
    do
    {
        let themesArr = try managedContext.fetch(fetchRequest)
        for theme in themesArr as! [NSManagedObject] {
            themes.append(FavoriteTheme(
                forumID: theme.value(forKey: "forumID") as! String,
                id: theme.value(forKey: "id") as! String,
                name: theme.value(forKey: "name") as! String,
                url: theme.value(forKey: "url") as! String
            ))
        }
        
        return themes
    }
    catch
    {
        print(error)
        return themes
    }
}

/**
 Добавить тему форума как избранную
 - Parameter themeData: Данные темы
 - Returns: Статус выполнения операции
 */
func addThemeToFavorite(themeData:FavoriteTheme) -> Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let userEntity = NSEntityDescription.entity(forEntityName: "FavoriteThemes", in: managedContext)!
    let theme = NSManagedObject(entity: userEntity, insertInto: managedContext)
    
    theme.setValue(themeData.forumID, forKeyPath: "forumID")
    theme.setValue(themeData.id, forKeyPath: "id")
    theme.setValue(themeData.name, forKeyPath: "name")
    theme.setValue(themeData.url, forKeyPath: "url")
    print ("theme:",theme)
    do {
        try managedContext.save()
        return true
        
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return false
    }
}

/**
 Удалить тему из избранного
 - Parameter id: Идентификатор форума
 */
func deleteFavoriteTheme(url:String) ->Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteThemes")
    fetchRequest.predicate = NSPredicate(format: "url = %@", url)
    
    do
    {
        let theme = try managedContext.fetch(fetchRequest)
        if theme.count > 0 {
            let objectToDelete = theme[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do{
                try managedContext.save()
                return true
            }
            catch
            {
                print(error)
                return false
            }
        }
    }
    catch
    {
        print(error)
    }
    return false
}

/**
 Проверка, сохранена ли такая тема в избранное
 - Parameter url: URL темы
 */
func isThemeAlreadyFavorite(url:String) -> Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteThemes")
    fetchRequest.predicate = NSPredicate(format: "url = %@", url)
    
        do {
            let count  = try managedContext.count(for: fetchRequest)
            return count > 0
        }
        catch {
            print("Error: \(error)")
            return false
        }
}


/**
 Удалить все избранные темы форума
 - Parameter id: ID родительского форума
 - Returns: Статус выполнения операции
 */
func deleteAllFavoriteThemesForForum(id:String) ->Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteThemes")
    fetchRequest.predicate = NSPredicate(format: "forumID = %@", id)
    
    do
    {
        let themes = try managedContext.fetch(fetchRequest)
        
        for theme in themes as! [NSManagedObject] {
            managedContext.delete(theme)
        }
            do{
                try managedContext.save()
                return true
            }
            catch
            {
                print(error)
                return false
            }
    }
    catch
    {
        print(error)
    }
    return false
}
