//
//  CurrentForum.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 17/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation

class CurrentForum {
    static let shared = CurrentForum()
    
    var id:String = "0"
    var url:String = ""
    var name = "My forum"
}
