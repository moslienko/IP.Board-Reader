//
//  SettingsViewController.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let fs = FontSize()

    @IBOutlet weak var switchTheme: UISwitch!
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Тема
//        if ThemeManager.currentTheme() == .theme2 {
//            switchTheme.isOn = true
//        }
//        else {
//            switchTheme.isOn = false
//        }
        
        //Шрифт
        let currentSize = fs.getCurrentSize()
        
        sizeSlider.isContinuous = false
        
        fontSizeLabel.text = String(currentSize)
        sizeSlider.setValue(Float(currentSize), animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("clicked")
        if indexPath.row == 2 {
            openAbout()
        }
    }
    
    @IBAction func swithThemeChange(_ sender: UISwitch) {
        //ThemeManager.applyTheme(theme: .theme2)
        
        let alertController = UIAlertController(title: "Тема изменена", message:
            "При следующем запуске приложения вы увидите выбранную тему", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func sizeSliderChange(_ sender: UISlider) {
        fontSizeLabel.text = String(lrintf(sizeSlider.value))
        fs.setSize(size: lrintf(sizeSlider.value))
    }
    
    func openAbout() {
        let alertController = UIAlertController(title: "О приложении", message:
            "Hello, world!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
