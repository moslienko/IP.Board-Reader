//
//  UserForums.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 16/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

fileprivate let realm = try! Realm()

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
 Получить сохраненные форумы из базы данных Realm
 - Returns: Сохраненные аудиокниги
 */
func getUserForums(_ limit:Int = 0) -> Results<UserForum>{
    let forums = realm.objects(UserForum.self).sorted(byKeyPath: "name", ascending: true)
    
    return forums
}

/**
 Сохранить форум в Core Data
 - Parameter forumData: Информация о главе
 - Returns: Статус выполнения операции
 */
func saveForum(forumData:UserForum, callback: @escaping (Bool,Error?) -> ()) -> Void {
    do {
        try realm.write {
            realm.add(forumData)
            callback (true,nil)
        }
    } catch let error as NSError {
        callback (false,error)
    }
}


/**
 Обновить форум
 - Parameter forumInfo: Данные о форуме
 - Returns: Статус выполнения операции
 */
func updateForum(id:String, url:String, callback: @escaping (Bool,Error?) -> ()) -> Void {
    guard let forum = realm.objects(FavoriteTheme.self).filter("id == \(id)").first else  {
        callback(false, nil)
        return
    }
    
    do {
        try realm.write {
            forum.url = url
            callback (true,nil)
        }
    } catch let error as NSError {
        callback (false,error)
    }
}

/**
 Удалить форум
 - Parameter id: Идентификатор форума
 */
func deleteForum(id:String, callback: @escaping (Bool,Error?) -> ()) -> Void {
    guard let forum = realm.objects(UserForum.self).filter("id == \(id)").first else  {
        callback(false, nil)
        return
    }
    
    do {
        try realm.write {
            realm.delete(forum)
            callback (true,nil)
        }
    } catch let error as NSError {
        callback (false,error)
    }
}
