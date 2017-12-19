//
//  FeedItemViewController.swift
//  WhatsNew
//
//  Created by loubna on 15/12/2017.
//  Copyright © 2017 Bulltech. All rights reserved.
//

import Foundation
import UIKit

class FeedItemViewController: UIViewController {
    
    var selectedFeedURL: String?
    @IBOutlet var myWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("afficher le lien url avant ")
        //     print(selectedFeedURL)
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: " ", with:"")
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: "\n", with:"")
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: "\t", with:"")
        print("afficher le lien url")
        //      print(selectedFeedURL)
        print("telecharger page")
        myWebView.loadRequest(URLRequest(url: URL(string: selectedFeedURL! as String)!))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
