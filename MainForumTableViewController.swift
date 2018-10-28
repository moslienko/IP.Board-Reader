//
//  MainForumTableViewController.swift
//  
//
//  Created by Pavel Moslienko on 27/10/2018.
//

import UIKit

class MainForumTableViewController: UITableViewController {
    
    @IBOutlet var toolbar: UITableView!
    let cellID = "cellMainForum"
    
    var data = (
        mainMenu: [String](),
        mainSubMenu:[[Any]]()
    )
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainTopics = getMainForumTopics()

        let nib = UINib.init(nibName: "MainForumCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        
        self.data.mainMenu = mainTopics.menu
        self.data.mainSubMenu = mainTopics.submenu
        
        tableView.reloadData()
        
        navigationController?.setToolbarHidden(true, animated: false)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.mainMenu.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.mainSubMenu[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MainForumTableViewCell
        
        let menuData = data.mainSubMenu[indexPath.section][indexPath.row] as! topicData

        cell.forumTopicTitle.text = menuData.title
        cell.countTopicMsg?.text = menuData.count

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data.mainMenu[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openSubForum", sender: tableView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openSubForum" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let clickedTopic = data.mainSubMenu[indexPath.section][indexPath.row] as! topicData
                print("click:",clickedTopic)
                
                
                if let destinationVC = segue.destination as? SubForumTableViewController {
                   destinationVC.subForumSeque.params.append(clickedTopic)
                }
            }
        }
    }
    

}
