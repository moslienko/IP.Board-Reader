//
//  ForumCell.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 16/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class ForumCell: UITableViewCell {

    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var nameForum: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layerView.layer.cornerRadius = 15
        layerView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
