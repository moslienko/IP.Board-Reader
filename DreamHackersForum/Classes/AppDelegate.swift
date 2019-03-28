//
//  AppDelegate.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 27/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window?.tintColor = UIColor(red:0.13, green:0.28, blue:0.58, alpha:1.0)
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem
        {
            print (shortcutItem.type)
            if shortcutItem.type == "com.moslienko.IPBoardReader.favorites" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController : UIViewController = storyboard.instantiateViewController(withIdentifier :"Forum_VC") as! MainForumTableViewController
                if let navigationController = self.window?.rootViewController as? UINavigationController {
                    
                    CurrentForum.shared.name = shortcutItem.localizedTitle
                    CurrentForum.shared.url = shortcutItem.userInfo!["url"] as! String
                    CurrentForum.shared.id = shortcutItem.userInfo!["id"] as! String
                    
                    navigationController.title = CurrentForum.shared.id
                    navigationController.pushViewController(initialViewController, animated: true)
                }
                else {
                    print("Navigation Controller not Found")
                }
            }
            
            if shortcutItem.type == "com.moslienko.IPBoardReader.settings" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController : UIViewController = storyboard.instantiateViewController(withIdentifier :"Settings_VC") as! SettingsViewController
                
                if let navigationController = self.window?.rootViewController as? UINavigationController {
                    navigationController.title = "ok"
                    
                    navigationController.pushViewController(initialViewController, animated: true)
                }
                else {
                    print("Navigation Controller not Found")
                }
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

