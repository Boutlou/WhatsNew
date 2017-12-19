//
//  XmlParserManager.swift
//  WhatsNew
//
//  Created by loubna on 15/12/2017.
//  Copyright © 2017 Bulltech. All rights reserved.
//

import Foundation

class XmlParserManager: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var img:  [AnyObject] = []
    var fdescription = NSMutableString()
    var fdate = NSMutableString()
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        //     print("----------------------------------------")
        //    print("initialisation du parseé")
        startParse(url)
        return self
    }
    
    //parser xml
    func startParse(_ url :URL) {
        //  print("je suis ds la fonction startparse debut de parse initiation")
        feeds = []
        parser = XMLParser(contentsOf: url)!
        //     print("delegate")
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        //   print("appel du methode parse")
        parser.parse()
    }
    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        //   print("je suis dans la fonction parser 1")
        element = elementName as NSString
        // print(element)
        if (element as NSString).isEqual(to: "item") {
            //     print("c'est un item")
            elements =  NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            link = NSMutableString()
            link = ""
            fdescription = NSMutableString()
            fdescription = ""
            fdate = NSMutableString()
            fdate = ""
        } else if (element as NSString).isEqual(to: "enclosure") {
            //      print("c'est enclosure")
            if let urlString = attributeDict["url"] {
                img.append(urlString as AnyObject)
            }
        }
        //     print("fini parse 1")
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //   print("je suis dans la fonction parser 2")
        if (elementName as NSString).isEqual(to: "item") {
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
            }
            if link != "" {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "description" as NSCopying)
            }
            if fdate != "" {
                elements.setObject(fdate, forKey: "pubDate" as NSCopying)
            }
            feeds.add(elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //    print("je suis dans la fonction parser 3")
        //    print(string)
        //   print("mon element est un ")
        //  print(element)
        if element.isEqual(to: "title") {
            ftitle.append(string)
        } else if element.isEqual(to: "link") {
            link.append(string)
        } else if element.isEqual(to: "description") {
            fdescription.append(string)
        } else if element.isEqual(to: "pubDate") {
            fdate.append(string)
        }
        //   print("j'ai fini parse 3")
    }
    
}

