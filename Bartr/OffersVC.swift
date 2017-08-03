//
//  OffersVC.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 7/27/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import UIKit
import Firebase

class OffersVC: UIViewController {

    
//    @IBOutlet weak var navDrawerBtn: UIBarButtonItem!
    
//    @IBOutlet weak var searchItemTF: UITextField!
//    @IBOutlet weak var searchPicker: UIPickerView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
//    var itemList = [String]()
    var userID: String!
    var item: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navDrawerBtn.target = self.revealViewController()
//        navDrawerBtn.action = #selector(SWRevealViewController.revealToggle(_:))
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
//        searchPicker.delegate = self
//        searchPicker.dataSource = self
//        searchItemTF.delegate = self
        
        userID = (FIRAuth.auth()?.currentUser?.uid)!
        

        self.itemNameLabel.text = item

//        DataService.ds.REF_ITEMS.observe(.value, with: {(snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshot{
//                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
//                        if itemDict["user"] as? String == self.userID! {
//                            let key = snap.key
//                            let item = Item(itemKey: key, itemData: itemDict)
//                            self.itemList.append(item.name)
//                        }
//                    }
//                }
//            }
//            
//            self.searchPicker.reloadAllComponents()
//        })

        
    }
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return itemList.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return itemList[row]
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.searchItemTF.text = itemList[row]
//        self.itemNameLabel.text = itemList[row]
//        self.searchPicker.isHidden = true
//        self.itemNameLabel.isHidden = false
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.searchPicker.isHidden = false
//        self.itemNameLabel.isHidden = true
//    }

}
