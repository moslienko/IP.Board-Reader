//
//  TopicCellTableViewCell.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class TopicCellTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
