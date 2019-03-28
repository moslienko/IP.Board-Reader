//
//  FavoriteTheme.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/03/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

struct FavoriteTheme {
    var forumID:String
    var id:String
    var name:String
    var url: String
    
    init(forumID:String,id:String,name:String,url:String) {
        self.forumID = forumID
        self.id = id
        self.name = name
        self.url = url
    }
}
