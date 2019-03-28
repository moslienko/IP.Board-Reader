//
//  TopicTableViewController.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit
import SafariServices
import JGProgressHUD

class TopicTableViewController: UITableViewController {
    
    let cellID = "cellTopic"
    var topic = [topicData]()
    var messages = [topicMsg]()
    var pages = [pageCount]()

    @IBOutlet weak var addFavoriteButton: UIBarButtonItem!
    
    enum favoriteImg:String {
        case alreadyFav = "favorites_full"
        case noFav = "favorites"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "TopicCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.applyTheme()

        if topic.count > 0 {
            self.navigationItem.title = topic[0].title
            
            pages = getTopicsPageList(urlTopic: topic[0].url)

            messages = getTopic(url: topic[0].url)
            self.tableView.reloadData()
            
            if isThemeAlreadyFavorite(url: topic[0].url) {
                addFavoriteButton.image = UIImage(named: favoriteImg.alreadyFav.rawValue)
            }
        }
        
        
        if pages.count > 0 {
            
            var toolbarPages = [UIBarButtonItem]()
            
            for i in pages {
                toolbarPages.append(UIBarButtonItem(title: i.number, style: .plain, target: self, action: #selector(getPageUrl(sender:))))
            }
            toolbarItems = toolbarPages
            
            navigationController?.setToolbarHidden(false, animated: true)
            self.navigationController?.toolbar.applyTheme()
        }
        else {
            navigationController?.setToolbarHidden(true, animated: true)
        }
        
    }


    @objc func getPageUrl(sender: UIBarButtonItem) {
        if self.pages.count > 0{
            let url = self.pages[Int(sender.title!)!-1].url
            getMessages(url:url)
        }
    }
    
    func getMessages(url:String) {
        self.messages = getTopic(url: url)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TopicCellTableViewCell
        
        let msgContent = messages[indexPath.row]
        
        cell.username?.text = msgContent.username
        cell.date?.text = msgContent.date
        
        let data = msgContent.message.data(using: String.Encoding.unicode)!
        
        let attrStr = try? NSAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        //HTML, что бы сохранить форматирование
        cell.message?.attributedText = attrStr
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.animate(index: indexPath.row)
    }
    
    /**
     Добавить тему в избранное
     */
    @IBAction func addToFavoriteClick(_ sender: UIBarButtonItem) {
        if self.topic.count > 0 {
            //Проверка
            let url = self.topic[0].url
            
            if isThemeAlreadyFavorite(url: url) {
                //Убрать
                deleteFavoriteTheme(url: url, callback: { (status, error) in
                    if status {
                        self.addFavoriteButton.image = UIImage(named: favoriteImg.noFav.rawValue)
                        let hud = JGProgressHUD(style: .dark)
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
                        hud.textLabel.text = "Theme deleted".localized;
                        hud.show(in: self.view)
                        hud.dismiss(afterDelay: 2.0)
                    }
                    else {
                        print ("Error: \(error)")
                        let hud = JGProgressHUD(style: .dark)
                        hud.indicatorView = JGProgressHUDErrorIndicatorView.init()
                        hud.textLabel.text = "Error delete theme".localized;
                        hud.show(in: self.view)
                        hud.dismiss(afterDelay: 2.0)
                    }
                })
            }
            else {
                //Сохранить
                let themeData = FavoriteTheme()
                themeData.forumID = CurrentForum.shared.id
                themeData.id = randomID(10) as String
                themeData.name = self.topic[0].title
                themeData.url = url
                
                addThemeToFavorite(theme: themeData, callback: { (status, error) in
                    if status {
                        self.addFavoriteButton.image = UIImage(named: favoriteImg.alreadyFav.rawValue)
                        let hud = JGProgressHUD(style: .dark)
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
                        hud.textLabel.text = "Theme added to favorite".localized;
                        hud.show(in: self.view)
                        hud.dismiss(afterDelay: 2.0)
                    }
                    else {
                        print ("Error: \(error)")
                        let hud = JGProgressHUD(style: .dark)
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
                        hud.textLabel.text = "Error add theme to favorite".localized;
                        hud.show(in: self.view)
                        hud.dismiss(afterDelay: 2.0)
                    }
                })
            }
        }
    }

    
    /**
     Открыть тему в Safari (Внутри программы)
     */
    @IBAction func openPageInBrowser(_ sender: UIBarButtonItem) {
        if topic.count > 0 {
            let url = URL(string: topic[0].url)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil)
        }
    }
    
    /**
     Поделиться ссылкой на тему
     */
    @IBAction func shareURL(_ sender: UIBarButtonItem) {
        if self.topic.count > 0 {
            let url = self.topic[0].url
            if url.isValidURL {
                let someText:String = self.topic[0].title
                let objectsToShare:URL = URL(string: url)!
                let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
                let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view

                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
