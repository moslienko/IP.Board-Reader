//
//  FontSize.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 30/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation

class FontSize {
    
    func setSize(size:Int) {
        UserDefaults.standard.set(size, forKey: "size")
    }
    
    func getCurrentSize() -> Int {
        var size = UserDefaults.standard.integer(forKey: "size")
       
        if size == 0 {
            size = 18
        }

        return size
    }
}
