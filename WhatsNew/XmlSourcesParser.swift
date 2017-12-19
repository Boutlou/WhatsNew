//
//  XmlSourcesParser.swift
//  WhatsNew
//
//  Created by loubna on 15/12/2017.
//  Copyright © 2017 Bulltech. All rights reserved.
//

import Foundation
import Foundation

class XmlSourcesParser: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var sources = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    //var de ma source
    var sname = NSMutableString()
    var scategorie = NSMutableString()
    var spays = NSMutableString()
    var surl = NSMutableString()
    var categorydemande : String = "Tout"
    var paysdemande : String = "Tout"
    var catsectioncrecherche : Bool = false
    var paysectioncrecherche : Bool = false
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        print("----------------------------------------")
        print("parser source des rss")
        startParse(url)
        return self
    }
    
    
    //parser xml
    func startParse(_ url :URL) {
        print("je suis ds la fonction startparse debut de parse initiation")
        sources = []
        parser = XMLParser(contentsOf: url)!
        print("delegate")
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        print("appel du methode parse")
        parser.parse()
    }
    
    func allSources() -> NSMutableArray {
        return sources
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("je suis dans la fonction parser 1")
        element = elementName as NSString
        print(element)
        if (element as NSString).isEqual(to: "source") && (attributeDict["tag1"]! == paysdemande || attributeDict["tag2"]! == paysdemande) {
            print("c'est la section du pays recherchée")
            paysectioncrecherche = true
            spays = ""
            spays = attributeDict["tag1"] as! NSMutableString
        }
        
        if (element as NSString).isEqual(to: "categorie") && (attributeDict["tag1"]! == categorydemande || attributeDict["tag2"]! == categorydemande)
        {
            print("c'est la section de categorie recherchée")
            catsectioncrecherche = true
            scategorie = ""
            scategorie = attributeDict["tag1"] as! NSMutableString
            
        }
        if (element as NSString).isEqual(to: "rss") && catsectioncrecherche && paysectioncrecherche {
            elements =  NSMutableDictionary()
            elements = [:]
            surl = ""
            sname = ""
            sname = attributeDict["name"] as! NSMutableString
        }
        print("fini parse 1")
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("je suis dans la fonction parser 2")
        if (elementName as NSString).isEqual(to: "rss") && catsectioncrecherche && paysectioncrecherche{
            if sname != "" {
                elements.setObject(sname, forKey: "name" as NSCopying)
            }
            if spays != "" {
                elements.setObject(spays, forKey: "pays" as NSCopying)
            }
            if scategorie != "" {
                elements.setObject(scategorie, forKey: "categorie" as NSCopying)
            }
            if surl != "" {
                elements.setObject(surl, forKey: "url" as NSCopying)
            }
            sources.add(elements)
        }
        
        if (elementName as NSString).isEqual(to: "categorie") && catsectioncrecherche && paysectioncrecherche{
            catsectioncrecherche = false
        }
        if (elementName as NSString).isEqual(to: "source") && paysectioncrecherche {
            paysectioncrecherche = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("je suis dans la fonction parser 3")
        //   print(string)
        //    print("mon element est un ")
        //    print(element)
        if element.isEqual(to: "url") && catsectioncrecherche && paysectioncrecherche {
            surl.append(string)
        }
        print("j'ai fini parse 3")
    }
    
}

