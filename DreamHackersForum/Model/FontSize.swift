//
//  FontSize.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 30/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation

class FontSize {
    
    /**
     Установить размер шрифта
     - Parameter size: Размер
     */
    func setSize(size:Int) {
        UserDefaults.standard.set(size, forKey: "size")
    }
    
    /**
     Получить размер шрифта
     - Returns: Размер
     */
    func getCurrentSize() -> Int {
        var size = UserDefaults.standard.integer(forKey: "size")
       
        if size == 0 {
            size = 18
        }

        return size
    }
}
