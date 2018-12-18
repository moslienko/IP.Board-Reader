//
//  Theme.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 18/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

extension UITableViewController {
    func applyTheme() {
        let themeManager = ThemeManager()
        if themeManager.currentTheme() == .dark {
            self.navigationController?.navigationBar.barStyle = .blackTranslucent
            self.tableView?.backgroundColor = UIColor.black
        }
    }
}

extension UIToolbar {
    func applyTheme() {
        let themeManager = ThemeManager()
        if themeManager.currentTheme() == .dark {
            self.barStyle = .blackTranslucent
            self.tintColor = UIColor.white
        }
    }
}

enum colorTheme:String {
    case light = "light"
    case dark = "dark"
}

class ThemeManager {
    /**
     Получить текущую тему
     - Returns: Тема
     */
    func currentTheme() -> colorTheme{
        let theme =  UserDefaults.standard.string(forKey: "theme")
        if theme == "dark" {
            return colorTheme.dark
        }
        
        return colorTheme.light
    }
    
    /**
     Сохранить тему
     - Parameter theme: Тнма
     - Returns: Темы
     */
    func saveTheme(theme choosenTheme:colorTheme) {
        var theme = colorTheme.light.rawValue
        if choosenTheme == .dark {
            theme = colorTheme.dark.rawValue
        }
        UserDefaults.standard.set(theme, forKey: "theme")
    }
}
