//
//  MainForumTableViewCell.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 27/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class MainForumTableViewCell: UITableViewCell {

    @IBOutlet weak var forumTopicTitle: UILabel!
    @IBOutlet weak var countTopicMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
