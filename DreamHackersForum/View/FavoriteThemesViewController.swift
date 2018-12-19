//
//  FavoriteThemesViewController.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 18/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class FavoriteThemesViewController: UITableViewController,UIViewControllerPreviewingDelegate {

    private let reuseIdentifier = "cellFavorite"
    
    var favoritesItem = [FavoriteTheme]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        registerForPreviewing(with: self, sourceView: tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print ("I D:",CurrentForum.shared.id)
        if CurrentForum.shared.id != "0" {
            self.favoritesItem = getFavoriteThemesForForum(id: CurrentForum.shared.id)
            print ("data:",self.favoritesItem)

        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoritesItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let themeManager = ThemeManager()
        if themeManager.currentTheme() == .dark {
              cell.textLabel?.textColor = UIColor.white
              cell.backgroundColor = UIColor.black
        }
        
        cell.textLabel?.text = self.favoritesItem[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let alert = UIAlertController(title: "Delete", message: "Delete theme from favorite?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default , handler:{ (UIAlertAction)in
                if deleteFavoriteTheme(url: self.favoritesItem[index.row].url) {
                    self.favoritesItem = getFavoriteThemesForForum(id: CurrentForum.shared.id)
                }
                else {
                    print ("error delete")
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in }))
            self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeOpenTheme" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let clickedTopic = self.favoritesItem[indexPath.row]
                print("click:",clickedTopic)
                
                if let topicPage = segue.destination as? TopicTableViewController {
                    topicPage.topic = [topicData(title: clickedTopic.name, url: clickedTopic.url, count: "0")]
                }
            }
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            return openTopicsForumVC(for: indexPath.row)
        }
        
        return nil
    }
    
    /**
     Получить контроллер темы форума
     - Parameter index: Индекс ячейки
     - Returns: VC
     */
    func openTopicsForumVC(for index: Int) -> TopicTableViewController {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TopicForum_VC") as? TopicTableViewController else {
            fatalError("Couldn't load detail view controller")
        }
        let clickedTopic = self.favoritesItem[index]
        vc.topic = [topicData(title: clickedTopic.name, url: clickedTopic.url, count: "0")]

        return vc
    }
    
    
}
