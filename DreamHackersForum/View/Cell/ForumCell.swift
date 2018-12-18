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
        if themeManager.currentTheme() == .dark {
           self.backgroundColor = UIColor.clear
           self.layerView.backgroundColor = UIColor.darkGray
           self.nameForum.textColor  = UIColor.white
           self.urlLabel.textColor  = UIColor.gray
        }
    }
}


class ForumCell: UITableViewCell {

    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var nameForum: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        layerView.layer.cornerRadius = 15
        layerView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
