//
//  Forum.swift
//  DreamHackersForum
//
//  Created by Pavel Moslienko on 27/10/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import SwiftSoup

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.utf16Offset(in: self))) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.utf16Offset(in: self)
        } else {
            return false
        }
    }
}

//Темы форума
typealias topicData = (title: String, url: String, count: String)
//Колечество страниц
typealias pageCount = (number: String, url: String)
//Сообщения на форуме
typealias topicMsg = (username: String, date: String, message: String)
//Основные форумы с разделами
typealias mainTopics = (title:String,menu:[topicData])
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
func getMainForumTopics() -> [mainTopics] {
    
    var menu = [String]()
    var menuInside = [[topicData]]()

    var topics = [mainTopics]()

    do {
        let url = "http://\(CurrentForum.shared.url)"
        
        let html = getHTMLContent(url: "\(String(describing: url))/lofiversion/index.php")
        
        print ("page:","\(String(describing: url))/lofiversion/index.php")
        
            let doc: Document = try SwiftSoup.parse(html)
            let menuDivs: Elements = try doc.select("div.forumwrap")

            if  menuDivs.array().count > 0 {
                
                let menuDiv:Element = menuDivs.first()!
                let menuDivElementLi: Elements = try menuDiv.select("li")

                let menuStrong: Elements = try menuDiv.select("strong")
            
                for _ in menuStrong {
                    menuInside.append([])
                    print ("menuInside:",menuInside)
                    for i in menuDivElementLi.enumerated() {
                        let tag = i.element.child(0).tag().getName()
                        
                        
                        if tag == "strong" {
                            menu.append(try i.element.child(0).text())
                            
                            topics.append((
                                title: try i.element.child(0).text(),
                                menu: [topicData(
                                    title: "",
                                    url: "",
                                    count: "Delete this"
                                    )]))

                        }
                        else {
                            if tag != "ul" {
                               
                                let count = menu.count - 1
                                print ("test count:",topics[count])
    
                                topics[count].menu.append(topicData(
                                        title: try i.element.child(0).text(),
                                        url: try i.element.child(0).attr("href"),
                                        count: try i.element.child(1).text()
                                ))
       
                                if menuInside.indices.contains(count) {
                                    menuInside[count].append(
                                        topicData( title: try i.element.child(0).text(),
                                                   url: try i.element.child(0).attr("href"),
                                                   count: try i.element.child(1).text()
                                        ))
                                }
                               
                                
                            }
                        }
                        
                    }
                    
                    for (i,j) in topics.enumerated() {
                        if j.menu[0].count == "Delete this" {
                            topics[i].menu.remove(at: 0)
                        }
                    }
                    
                    print ("topics:",topics)
                    return topics
                }
                
                
            }

    } catch Exception.Error( _, let message) {
        print(message)
    } catch {
        print("error")
    }
    return topics
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
    let fs = FontSize()
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
                    message: "<div style=\"font-size: \(fs.getCurrentSize())\">\(content)</div>"
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

/**
 Проверка, работает ли сайт на IP.Board
 - Parameter url: URL сайта
 - Returns: Результат проверки
 */
func isIPBoardSite(url:String) -> Bool {
    let html = getHTMLContent(url: url)
    
    do {
        let doc: Document = try SwiftSoup.parse(html)

        let copyright: Elements = try doc.select("div.copyright")
        if copyright.array().count > 0 {
            let info: Elements = try copyright.first()!.select("a")
            if info.array().count > 1 {
                let label = try info.array()[1].text()
                if label == "IP.Board" {
                    return true
                }
            }
        }

        return false

    } catch Exception.Error( _, let message) {
        print(message)
        return false
    } catch {
        print("error")
        return false
    }
}

/**
 Получить название сайта
 - Parameter url: URL сайта
 - Returns: Название
 */
func getSiteName(url:String) -> String {
    let defaultName = "My forum"
    
    let html = getHTMLContent(url: url)
    
    do {
        let doc: Document = try SwiftSoup.parse(html)
        
        let title: Elements = try doc.select("title")
        if title.first() != nil {
            return try title.text()
        }
        
        return defaultName
        
    } catch Exception.Error( _, let message) {
        print(message)
        return defaultName
    } catch {
        print("error")
        return defaultName
    }
}
