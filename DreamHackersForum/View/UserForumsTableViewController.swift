//
//  UserForumsTableViewController.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 16/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class UserForumsTableViewController: UITableViewController {
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
        let alert = UIAlertController(title: "Enter URL", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            
            if textField.text != "" {
                let url = textField.text
                
                if (url?.isValidURL)! {
                    let siteName = getSiteName(url: url!)
                    
                    if isIPBoardSite(url: url!){
                        if saveForum(forumData: UserForum(id: randomID(10) as String, name: siteName, url: URL(string: url!)!)) {
                            self.userForums = getUserForums()
                        }
                    }
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter url main page forum IT.Board"
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sequeOpenForum", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeOpenForum" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let clickCellData = self.userForums[indexPath.row]
                
                if let destinationVC = segue.destination as? MainForumTableViewController {
                    destinationVC.forumInfo = [clickCellData]
                }
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
