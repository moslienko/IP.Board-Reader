//
//  FavoriteTheme.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/03/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//
import RealmSwift

class FavoriteTheme: Object {
    @objc dynamic var forumID = ""
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var url = ""
}
