//
//  HomeViewController.swift
//  WhatsNew
//
//  Created by loubna on 15/12/2017.
//  Copyright © 2017 Bulltech. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class HomeViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate   {
    
    @IBOutlet weak var pickerFilter: UIPickerView!
    
    @IBOutlet weak var OkFilterButtom: UIButton!
    
    var pays = ["Tout","Maroc","France"]
    var categorie = ["Tout","Sport","Politique","Art et Culture","Economie","Societe"]
    var payselected : String = "Tout"
    var categorieselected : String = "Tout"
    
    
    override func viewDidLoad() {
        let navbar = self.navigationController?.navigationBar
        navbar?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:10)
        navbar?.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
        OkFilterButtom.layer.cornerRadius = 10
        OkFilterButtom.layer.borderWidth = 0.4
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        if (component==0){
            return pays.count
        }
        return categorie.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component==0){
            return pays[row]
        }
        return categorie[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let countryselectedrow = pickerFilter.selectedRow(inComponent: 0)
        let categoryselectedrow = pickerFilter.selectedRow(inComponent: 1)
        payselected = pays[countryselectedrow]
        categorieselected = categorie[categoryselectedrow]
        print(payselected + " " + categorieselected)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! FeedListViewController
        receiverVC.filtercateg = categorieselected
        receiverVC.filterpays = payselected
    }
    
}








