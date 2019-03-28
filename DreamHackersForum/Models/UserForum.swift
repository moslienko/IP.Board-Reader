//
//  UserForum.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/03/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//
import RealmSwift

class UserForum: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var url = ""
}
