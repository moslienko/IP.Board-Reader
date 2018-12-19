//
//  UserForumsTableViewController.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 16/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class UserForumsTableViewController: UITableViewController,UIViewControllerPreviewingDelegate {
    private let reuseIdentifier = "cellAllForums"

    var userForums = [UserForum]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "ForumCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.rowHeight = 110
        self.applyTheme()

        registerForPreviewing(with: self, sourceView: tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.userForums = getUserForums()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userForums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ForumCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ForumCell
        
        let data = self.userForums[indexPath.row]
        
        cell.nameForum?.text = data.name
        cell.urlLabel?.text = "\(data.url)"
        
        return cell
    }
    

    @IBAction func addNewForum(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter url".localized, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add".localized, style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            
            if textField.text != "" {
                let url = textField.text
                
                if (url?.isValidURL)! {
                    let siteName = getSiteName(url: url!)
                    
                    if isIPBoardSite(url: url!){
                        if saveForum(forumData: UserForum(id: randomID(10) as String, name: siteName, url: url!)) {
                            self.userForums = getUserForums()
                        }
                    }
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Forum should based on IP.Board".localized
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.animate(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sequeOpenForum", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeOpenForum" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let clickCellData = self.userForums[indexPath.row]
                
                if segue.destination is MainForumTableViewController {
                    CurrentForum.shared.url = clickCellData.url
                    CurrentForum.shared.id = clickCellData.id
                    CurrentForum.shared.name = clickCellData.name
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
            return openForumVC(for: indexPath.row)
        }
        
        return nil
    }
    
    /**
     Получить контроллер форума
     - Parameter section: Индекс секции
     - Returns: VC
     */
    func openForumVC(for index: Int) -> MainForumTableViewController {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Forum_VC") as? MainForumTableViewController else {
            fatalError("Couldn't load detail view controller")
        }
        let clickCellData = self.userForums[index]
        
        CurrentForum.shared.url = clickCellData.url
        CurrentForum.shared.id = clickCellData.id
        CurrentForum.shared.name = clickCellData.name
        
        return vc
    }
}
