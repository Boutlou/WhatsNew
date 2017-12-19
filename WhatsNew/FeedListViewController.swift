//
//  FeedListViewController.swift
//  WhatsNew
//
//  Created by loubna on 15/12/2017.
//  Copyright © 2017 Bulltech. All rights reserved.
//

import Foundation

import UIKit

class FeedListViewController: UITableViewController, XMLParserDelegate {
    
    @IBOutlet weak var Labelfilter: UILabel!
    var myFeed : NSArray = []
    var feedImgs: [AnyObject] = []
    var url: URL!
    
    var mysources : NSArray = []
    var filtercateg : String = ""
    var filterpays : String = ""
    var rsscontener : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Labelfilter.text = filtercateg + "/" + filterpays
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.backgroundColor = UIColorFromRGB(rgbValue: 0xa8a8a8)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loeadsource()
        //loadData()
    }
    
    @IBAction func refreshFeed(_ sender: Any) {
        
        //loadData()
    }
    func loeadsource () {
        let bundleURL = Bundle.main.url(forResource: "rsssources", withExtension: "xml")
        print("*************************$")
        print("\(bundleURL!)")
        rsscontener = bundleURL
        var sourceparser : XmlSourcesParser = XmlSourcesParser()
        sourceparser.categorydemande = filtercateg
        sourceparser.paysdemande = filterpays
        sourceparser = sourceparser.initWithURL(rsscontener) as! XmlSourcesParser
        mysources = sourceparser.sources
        print("----------------mes sources-----------")
        // for i in mysources {
        //   print(i)
        //}
        for i in 0..<mysources.count {
            let tmp = (mysources.object(at: i) as AnyObject).object(forKey: "url") as? String
            //    print(tmp!)
            loadData(tmp!)
        }
        print ("--------------------------------------")
    }
    
    
    // source des rss
    func loadData(_ data: String) {
        var cleandata : String = data.replacingOccurrences(of: " ", with:"")
        cleandata = cleandata.replacingOccurrences(of: "\n", with:"")
        cleandata = cleandata.replacingOccurrences(of: "\t", with:"")
        //   print("------ donne aprer clean------")
        //  print(cleandata)
        url = URL(string: cleandata)!
        loadRss(url);
    }
    
    // fonction recupere les données du fichier rss
    func loadRss(_ data: URL) {
        // XmlParserManager instance/object/variable
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager
        // Put feed in array
        feedImgs = myParser.img as [AnyObject]
        myFeed = myParser.feeds
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let selectedFURL: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "link") as! String
            // Instance of our feedpageviewcontrolelr
            let fivc: FeedItemViewController = segue.destination as! FeedItemViewController
            fivc.selectedFeedURL = selectedFURL as String
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        } else {
            cell.backgroundColor = UIColor(white: 1, alpha: 1.0)
        }
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.textColor = UIColor.black
        
        // Load feed iamge.
        if (feedImgs.count != 0){
            let url = NSURL(string:feedImgs[indexPath.row] as! String)
            let data = NSData(contentsOf:url! as URL)
            var image = UIImage(data:data! as Data)
            image = resizeImage(image: image!, toTheSize: CGSize(width: 70, height: 70))
            let cellImageLayer: CALayer?  = cell.imageView?.layer
            cellImageLayer!.cornerRadius = 35
            cellImageLayer!.masksToBounds = true
            cell.imageView?.image = image
        }
        // feed text
        cell.textLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String
      
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "pubDate") as? String
        
        return cell
    }
    
    //fonction recuperation de UIColor a partir de son code RGB
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    //fonction redimentionnement de l'image
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
}
