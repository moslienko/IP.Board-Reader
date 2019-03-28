//
//  UserForumsTableViewController.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 16/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit
import JGProgressHUD
import RealmSwift

class UserForumsTableViewController: UITableViewController,UIViewControllerPreviewingDelegate {
    private let reuseIdentifier = "cellAllForums"
    
    @IBOutlet var backgroundTableView: UIView!


    var userForums: Results<UserForum>! {
        didSet {
            self.tableView.reloadData()
            if userForums.count == 0 {
                self.tableView.backgroundView = self.backgroundTableView
            }
            else {
                 self.tableView.backgroundView = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.shortcutItems = getHomeIconShortcuts()

        let nib = UINib.init(nibName: "ForumCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.rowHeight = 94
        self.applyTheme()
        registerForPreviewing(with: self, sourceView: tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading".localized
        hud.show(in: self.view)
        
        self.userForums = getUserForums()
        
        hud.dismiss()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userForums == nil ? 0 : userForums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ForumCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ForumCell
        cell.selectionStyle = .none
        
        let data = self.userForums[indexPath.row]
        
        cell.tableViewCellContent.textLabel?.text = data.name
        cell.tableViewCellContent.detailTextLabel?.text = "\(data.url)"
        
        let url = URL(string: "http://www.\(data.url)/favicon.ico")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            if data != nil {
                DispatchQueue.main.async {
                    cell.tableViewCellContent.imageView?.image = UIImage(data: data!)
                }
            }
        }
        
        return cell
    }
    
    //MARK: - Анимация при касании
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = tableView.cellForRow(at: indexPath) as? ForumCell {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = tableView.cellForRow(at: indexPath) as? ForumCell {
               cell.transform = .identity
            }
        }
    }

    @IBAction func addNewForum(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter url".localized, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add".localized, style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            
            if textField.text != "" {
                let url = textField.text
                
                let hud = JGProgressHUD(style: .dark)

                if (url?.isValidURL)! {
                    let siteName = getSiteName(url: url!)
                
                    if isIPBoardSite(url: url!){
                        let forum = UserForum()
                        forum.id = randomID(10) as String
                        forum.name = siteName
                        forum.url = url!
                        
                        saveForum(forumData: forum, callback: { (status, error) in
                            if status {
                                self.userForums = getUserForums()
                                hud.textLabel.text = "Forum added".localized;
                                hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
                                hud.show(in: self.view)
                                hud.dismiss(afterDelay: 2.0)
                            }
                            else {
                                print ("Error: \(error)")
                                hud.textLabel.text = "Error save forum".localized;
                            }
                        })
                    }
                    else {
                        hud.indicatorView = JGProgressHUDErrorIndicatorView.init()
                        hud.textLabel.text = "Forum should based on IP.Board".localized;
                        hud.show(in: self.view)
                        hud.dismiss(afterDelay: 2.0)
                    }
                }
                else {
                    hud.indicatorView = JGProgressHUDErrorIndicatorView.init()
                    hud.textLabel.text = "Not correct URL".localized;
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 2.0)
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
