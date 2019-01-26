//
//  HomeIconShortcuts.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 23/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit

/**
 Получить элементы shortcuts для иконки приложения (3D Touch)
 */
func getHomeIconShortcuts() -> [UIApplicationShortcutItem] {
    var link = [UIApplicationShortcutItem]()
    let userForums = getUserForums(3) //Получить 3 сохраненных форума
    for forum in userForums {
        link += [UIApplicationShortcutItem(type: "com.moslienko.IPBoardReader.favorites", localizedTitle: forum.name, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "favorites"), userInfo: [
            "id":forum.id as NSSecureCoding,
            "url":forum.url as NSSecureCoding])]
    }
    link += [UIApplicationShortcutItem(type: "com.moslienko.IPBoardReader.settings", localizedTitle: "Settings", localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "icons8-settings-30"), userInfo: nil)]
    
    return link
}
