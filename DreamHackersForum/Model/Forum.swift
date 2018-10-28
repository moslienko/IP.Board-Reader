//
//  Forum.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 27/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import SwiftSoup

//Темы форума
typealias topicData = (title: String, url: String, count: String)
//Колечество страниц
typealias pageCount = (number: String, url: String)
//Сообщения на форуме
typealias topicMsg = (username: String, date: String, message: String)

/**
 Получить HTML содержимое страницы
 - Parameter url: URL страницы
 - Returns: Строка, содержащая код страницы
 */
func getHTMLContent(url:String) -> String {
    let myURL = URL(string: url)
    
    do {
        let html = try String(contentsOf: myURL!, encoding: .windowsCP1251)
        return html
    }
    catch {
        return ""
    }
}

/**
 Получить список разделов форума
 - Returns: Массив со списком названий разделов, массив со списком тем в каждом разделе
 */
func getMainForumTopics() -> (menu:[String], submenu:[[Any]]) {
    
    var menu = [String]()
    var menuInside = [[topicData]]()

    do {
        
            let html = getHTMLContent(url: "http://forum.dreamhackers.org/lofiversion/index.php")
        
            let doc: Document = try SwiftSoup.parse(html)
            let menuDiv: Element = try doc.select("div.forumwrap").first()!
            
            let menuDivElementLi: Elements = try menuDiv.select("li")
            
            let menuStrong: Elements = try menuDiv.select("strong")
        
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

    } catch Exception.Error( _, let message) {
        print(message)
    } catch {
        print("error")
    }
    return (menu:menu, submenu:menuInside)
}

/**
 Получить список подфорумов определенного раздела
 - Parameter url: URL раздела
 - Returns: Массив со списком подфорумов
 */
func getSubTopics(url:String) -> [topicData] {
    var menu = [topicData]()
    
    do {
        
        let html = getHTMLContent(url: url)
        
        let doc: Document = try SwiftSoup.parse(html)
        let menuDiv: Element = try doc.select("div.topicwrap").first()!
        
        let menuDivElementLi: Elements = try menuDiv.select("li")
        
        for i in menuDivElementLi.enumerated() {
            
                    menu.append(
                        topicData( title: try i.element.child(0).text(),
                                   url: try i.element.child(0).attr("href"),
                                   count: try i.element.child(1).text()))
                    
                }

        return menu
        
    } catch Exception.Error( _, let message) {
        print(message)
    } catch {
        print("error")
    }
    return menu
}


/**
 Получить топик
 - Parameter url: URL топика
 - Returns: Массив со списком сообщений в теме
 */
func getTopic(url:String) -> [topicMsg] {
    var menu = [topicMsg]()
    
    do {
        
        let html = getHTMLContent(url: url)
        
        let doc: Document = try SwiftSoup.parse(html)
        let menuDiv: Elements = try doc.select("div.postwrapper")

        for i in menuDiv {
            
            let topBar = try i.select("div.posttopbar").first()
            let messageContent = try i.select("div.postcontent").first()
            
            /*Цитируемое сообщение выделяется курсивом*/
            let content1 = try messageContent?.html().replacingOccurrences(of: "<div class=\"quotemain\">", with: "<i>", options: .literal, range: nil)
            
            let content = content1!.replacingOccurrences(of: "</div>", with: "</i>", options: .literal, range: nil)
            //HTML для сообщения, что бы сохранить форматирование

            menu.append(
                topicMsg(
                    username: try (topBar?.child(0).text())!,
                    date: try (topBar?.child(1).text())!,
                    message: "<div style=\"font-size: 17px\">\(content)</div>"
                    //message: try (messageContent?.text())!
            ))
            
        }
        return menu
        
    } catch Exception.Error( _, let message) {
        print(message)
    } catch {
        print("error")
    }
    return menu
}


/**
 Получить список страниц
 - Parameter urlTopic: URL подфорума или топика
 - Returns: Массив со списком страниц - Номер и URL
*/
func getTopicsPageList(urlTopic:String) -> [pageCount] {
    var pages =  [pageCount]()

    let html = getHTMLContent(url: urlTopic)
    
    do {
    let doc: Document = try SwiftSoup.parse(html)
    // Родительский блок
    let menuDiv: Elements = try doc.select("div.ipbpagespan")
        
        if menuDiv.array().count > 0 {
            //Есть топики, в которых только одна страница
            let link: Elements = try menuDiv.first()!.select("a")
            //Перечисление страниц
            for i in link {
                pages.append(pageCount(
                    number: try i.text(),
                    url: try i.attr("href")
                ))
                
            }
        }

        print ("pages:",pages)
        return pages
        
    } catch Exception.Error( _, let message) {
        print(message)
    } catch {
        print("error")
    }
    return pages
}
