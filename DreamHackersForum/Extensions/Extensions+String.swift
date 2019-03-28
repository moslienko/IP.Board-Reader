//
//  Extensions+String.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/03/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

import Foundation

extension String {
    //Проверка валидности введенного url адреса
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.utf16Offset(in: self))) {

            return match.range.length == self.endIndex.utf16Offset(in: self)
        } else {
            return false
        }
    }
    
    //Локализация
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
