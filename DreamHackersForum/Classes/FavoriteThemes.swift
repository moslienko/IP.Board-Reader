//
//  FavoriteThemes.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 17/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

fileprivate let realm = try! Realm()

/**
 Получить избранные темы форума
 - Parameter id: ID родительского форума
 - Returns: Темы
 */
func getFavoriteThemesForForum(id:String) -> Results<FavoriteTheme>{
    let themes = realm.objects(FavoriteTheme.self).filter("forumID = \(id)")

    return themes
}

/**
 Добавить тему форума как избранную
 - Parameter themeData: Данные темы
 - Returns: Статус выполнения операции
 */
func addThemeToFavorite(theme:FavoriteTheme, callback: @escaping (Bool,Error?) -> ()) -> Void {
    do {
        try realm.write {
            realm.add(theme)
            callback (true,nil)
        }
    } catch let error as NSError {
        callback (false,error)
    }
}

/**
 Удалить тему из избранного
 - Parameter id: Идентификатор форума
 */
func deleteFavoriteTheme(url:String, callback: @escaping (Bool,Error?) -> ()) -> Void {
    guard let theme = realm.objects(FavoriteTheme.self).filter("url == \(url)").first else  {
        callback(false, nil)
        return
    }

    do {
        try realm.write {
            realm.delete(theme)
            callback (true,nil)
        }
    } catch let error as NSError {
        callback (false,error)
    }
}

/**
 Проверка, сохранена ли такая тема в избранное
 - Parameter url: URL темы
 */
func isThemeAlreadyFavorite(url:String) -> Bool{
    return realm.objects(FavoriteTheme.self).filter("url == \(url)").count > 0
}

/**
 Удалить все избранные темы форума
 - Parameter id: ID родительского форума
 - Returns: Статус выполнения операции
 */
func deleteAllFavoriteThemesForForum(id:String, callback: @escaping (Bool,Error?) -> ()) -> Void {
    let themes = realm.objects(FavoriteTheme.self).filter("forumID == \(id)")
    
    if themes.count > 0 {
        do {
            try realm.write {
                realm.delete(themes)
                callback (true,nil)
            }
        } catch let error as NSError {
            callback (false,error)
        }
    }
    else {
         callback(false, nil)
    }
}
