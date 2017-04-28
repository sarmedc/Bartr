//
//  MyListVC.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 4/25/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MyListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var myListView: UIView!
    @IBOutlet var addItemView: UIView!
    
    @IBOutlet weak var imageAdd: UIImageView!
    
    
//    @IBOutlet weak var visualEffectView: UIVisualEffectView!
//    var effect: UIVisualEffect!
    
    
    var items = [Item]()
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Visual Effect View (Blur)
//        effect = visualEffectView.effect
//        visualEffectView.effect = nil
//        addItemView.layer.cornerRadius = 5
        
        // Image picker for add item
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_ITEMS.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot{
                    print("SNAP \(snap)")
                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Item(itemKey: key, itemData: itemDict)
                        self.items.append(item)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell{
            cell.configureCell(item: item)
            return cell
        } else{
            return ItemCell()
        }
        
    }
    
    func animateIn(){
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
//        self.myListView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        addItemView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
//            self.visualEffectView.effect = self.effect
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.addItemView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
//            self.myListView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            
        }) { (success: Bool) in
            self.addItemView.removeFromSuperview()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
        } else {
            print("TOOP: A valid image was not selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func addPopupTapped(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func cancelPopupTapped(_ sender: Any) {
        animateOut()
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("TOOP: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    
    
//    @IBAction func itemPopUpTapped(_ sender: Any) {
//        let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addItemPopUp") as! PopUpViewController
//        self.addChildViewController(addItemVC)
//        addItemVC.view.frame = self.view.frame
//        self.view.addSubview(addItemVC)
//        addItemVC.didMoveToParentViewController(self)
//    }
}
