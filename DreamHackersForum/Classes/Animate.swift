//
//  Animate.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 19/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit
 
extension UITableViewCell {
    /**
        Анимация появления для ячеек таблиц
        - Parameter index: Индекс ячейки
    */
    func animate(index:Int) {
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 30, 0)
        self.layer.transform = transform
        self.contentView.alpha = 0
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.03 * Double(index),
            animations: {
                self.layer.transform = CATransform3DIdentity
                self.contentView.alpha = 1
        })
    }
}
