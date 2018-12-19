//
//  SettingsViewController.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let theme = ThemeManager()
    let fs = FontSize()

    @IBOutlet weak var switchTheme: UISwitch!
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Тема
        if self.theme.currentTheme() == colorTheme.dark {
            switchTheme.isOn = true
        }
        else {
            switchTheme.isOn = false
        }
        
        //Шрифт
        let currentSize = fs.getCurrentSize()
        
        sizeSlider.isContinuous = false
        
        fontSizeLabel.text = String(currentSize)
        sizeSlider.setValue(Float(currentSize), animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            openAbout()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.animate(index: indexPath.row)
    }
    
    @IBAction func swithThemeChange(_ sender: UISwitch) {
        if switchTheme.isOn {
            self.theme.saveTheme(theme: colorTheme.dark)
        }
        else {
            self.theme.saveTheme(theme: colorTheme.light)
        }
        
        let alertController = UIAlertController(title: "Theme changed".localized, message:
           "Reload the app to see new theme".localized, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func sizeSliderChange(_ sender: UISlider) {
        fontSizeLabel.text = String(lrintf(sizeSlider.value))
        fs.setSize(size: lrintf(sizeSlider.value))
    }
    
    func openAbout() {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String

        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        
        let alertController = UIAlertController(title: "About app".localized, message:
            "\(appName) \("version".localized) \(version.localized).\r\n \("IP.Board is a product of Invision Power Services Inc. This application is not an official client, allowing you to view the forums running on this system.".localized)", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
