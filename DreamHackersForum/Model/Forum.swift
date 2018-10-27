//
//  Forum.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 27/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import SwiftSoup

typealias topicData = (title: String, url: String, count: String)

func test() -> (menu:[String], submenu:[[Any]]) {
    
    var menu = [String]()
    var menuInside = [[topicData]]()

    do {
        
        let myURLString = "http://forum.dreamhackers.org/lofiversion/index.php"
        let myURL = URL(string: myURLString)
        
        do {
            let html = try String(contentsOf: myURL!, encoding: .windowsCP1251)
            //print("HTML : \(html)")
            
            let doc: Document = try SwiftSoup.parse(html)
            let menuDiv: Element = try doc.select("div.forumwrap").first()!
            
            let menuDivElementLi: Elements = try menuDiv.select("li")
            
            let menuStrong: Elements = try menuDiv.select("strong")
            print ("menuStrong:",menuStrong.array().count)
            
            for _ in menuStrong {
                menuInside.append([])
            }

            for i in menuDivElementLi.enumerated() {
                let tag = i.element.child(0).tag().getName()
                
                if tag == "strong" {
                    menu.append(try i.element.child(0).text())
                }
                else {
                    if tag != "ul" {

                            let count = menu.count - 1
                            
                            menuInside[count].append(
                                topicData( title: try i.element.child(0).text(),
                                            url: try i.element.child(0).attr("href"),
                                            count: try i.element.child(1).text())
                            )

                    }
                }

            }
            
            return (menu:menu, submenu:menuInside)
            
        } catch let error {
            print("Error: \(error)")
        }
 
       

    } catch Exception.Error(let type, let message) {
        print(message)
    } catch {
        print("error")
    }
    return (menu:menu, submenu:menuInside)
}
