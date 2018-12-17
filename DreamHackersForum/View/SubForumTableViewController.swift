//
//  SubForumTableViewController.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 28/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class SubForumTableViewController: UITableViewController {
    let cellID = "cellSubForum"
    
    var subForumSeque = (
        params: [topicData](),
        mainSubMenu:[topicData]()
    )
    
    var pages = [pageCount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "MainForumCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        print (subForumSeque)

        if subForumSeque.params.count > 0 {
            self.navigationItem.title = subForumSeque.params[0].title
            let url = subForumSeque.params[0].url

            pages = getTopicsPageList(urlTopic: url)
            
            //Загрузить первую страницу
            getPage(url: url)
            
            if pages.count > 0 {
            
                var toolbarPages = [UIBarButtonItem]()
                
                for i in pages {
                    toolbarPages.append(UIBarButtonItem(title: i.number, style: .plain, target: self, action: #selector(getPageUrl(sender:))))
                }
                toolbarItems = toolbarPages
                
                navigationController?.setToolbarHidden(false, animated: true)
            }
            else {
                navigationController?.setToolbarHidden(true, animated: true)
            }
            
        }
        
    }
    
    @objc func getPageUrl(sender: UIBarButtonItem) {
        if self.pages.count > 0{
            let url = self.pages[Int(sender.title!)!-1].url
            getPage(url:url)
        }
    }
    
    func getPage(url:String) {
        self.subForumSeque.mainSubMenu = getSubTopics(url: url)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subForumSeque.mainSubMenu.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MainForumTableViewCell
        
        let menuData = subForumSeque.mainSubMenu[indexPath.row]

        cell.forumTopicTitle.text = menuData.title
        cell.countTopicMsg?.text = menuData.count
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openTopic", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openTopic" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let clickedTopic = subForumSeque.mainSubMenu[indexPath.row] 
                print("click:",clickedTopic)
                
                
                if let destinationVC = segue.destination as? TopicTableViewController {
                    destinationVC.topic = [clickedTopic]
                }
            }
        }
    }
    
    
}
