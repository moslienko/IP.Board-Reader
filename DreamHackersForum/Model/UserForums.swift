//
//  UserForums.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 16/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct UserForum {
    var id:String
    var name:String
    var url:String
    
    init(id:String,name:String,url:String) {
        self.id = id
        self.name = name
        self.url = url
    }
}

/**
 Создание рандомного идентификатора
 - Parameter len: Длина
 - Returns: ID
**/
func randomID (_ len : Int) -> NSString {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomString : NSMutableString = NSMutableString(capacity: len)
    for _ in 0 ..< len {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    return randomString
}


/**
 Получить сохраненные форумы из CoreData
 - Returns: Сохраненные аудиокниги
 */
func getUserForums() -> [UserForum]{
    var forum = [UserForum]()
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return forum }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserForums")
    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
    
    do {
        let result = try managedContext.fetch(fetchRequest)
        for data in result as! [NSManagedObject] {
            forum.append(UserForum(
                id: data.value(forKey: "id") as! String,
                name: data.value(forKey: "name") as! String,
                url: data.value(forKey: "url") as! String
            ))
        }
        
        return forum
        
    } catch {
        print("Failed")
        return forum
        
    }
}

/**
 Сохранить форум в Core Data
 - Parameter forumData: Информация о главе
 - Returns: Статус выполнения операции
 */
func saveForum(forumData:UserForum) -> Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let userEntity = NSEntityDescription.entity(forEntityName: "UserForums", in: managedContext)!
    
    let book = NSManagedObject(entity: userEntity, insertInto: managedContext)
    
    let url = URL(string: forumData.url)?.host
    
    book.setValue(forumData.id, forKeyPath: "id")
    book.setValue(forumData.name, forKeyPath: "name")
    book.setValue(url, forKeyPath: "url")
    
    do {
        try managedContext.save()
        return true
        
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return false
    }
}


/**
 Обновить форум
 - Parameter forumInfo: Данные о форуме
 - Returns: Статус выполнения операции
 */
func updateForum(forumInfo:UserForum) -> Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserForums")
    fetchRequest.predicate = NSPredicate(format: "id = %@", forumInfo.id)
    
    do
    {
        let forum = try managedContext.fetch(fetchRequest)
        
        if forum.count > 0 {
            let objectUpdateForum = forum[0] as! NSManagedObject
            objectUpdateForum.setValue(forumInfo.name, forKey: "name")
            
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
        return false
    }
    return false
}

/**
 Удалить форум
 - Parameter id: Идентификатор форума
 */
func deleteForum(id:String) ->Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserForums")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    
    do
    {
        let forum = try managedContext.fetch(fetchRequest)
        if forum.count > 0 {
            let objectToDelete = forum[0] as! NSManagedObject
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
