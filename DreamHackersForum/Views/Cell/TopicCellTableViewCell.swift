//
//  TopicCellTableViewCell.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

extension TopicCellTableViewCell {
    func applyTheme() {
        let themeManager = ThemeManager()
        if themeManager.currentTheme() == .dark {
            self.backgroundColor = UIColor.black
            self.username.textColor = UIColor.lightGray
            self.date.textColor = UIColor.gray
            self.message.textColor = UIColor.white
            self.message.backgroundColor = UIColor.lightGray
            
            self.message.layer.masksToBounds = true
            self.message.layer.cornerRadius = 7
        }
    }
}

class TopicCellTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
    }
    
}
