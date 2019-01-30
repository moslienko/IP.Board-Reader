//
//  ForumCell.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 16/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

extension ForumCell {
    func applyTheme() {
        let themeManager = ThemeManager()
        
        tableViewCellContent.layer.cornerRadius = 7
        tableViewCellContent.layer.masksToBounds = false
        
        tableViewCellContent.layer.shadowColor = UIColor.gray.cgColor
        tableViewCellContent.layer.shadowOpacity = 0.3
        tableViewCellContent.layer.shadowOffset = CGSize.zero
        tableViewCellContent.layer.shadowRadius = 6
        
        if themeManager.currentTheme() == .dark {
           self.backgroundColor = UIColor.clear
            self.tableViewCellContent.backgroundColor = UIColor.darkGray
            self.tableViewCellContent.textLabel?.textColor = UIColor.white
            self.tableViewCellContent.detailTextLabel?.textColor = UIColor.gray
        }
    }
}


class ForumCell: UITableViewCell {

    @IBOutlet weak var tableViewCellContent: UITableViewCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
