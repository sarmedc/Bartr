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

class MyListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var myListView: UIView!
    @IBOutlet var addItemView: UIView!
    
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var itemPriceTF: UITextField!
    @IBOutlet weak var itemDescriptionTF: UITextView!
    
    var imageSelected = false
    
//    let currUserItems = DataService.ds.REF_CURRENT_USER.child("items")
    
    
//    @IBOutlet weak var visualEffectView: UIVisualEffectView!
//    var effect: UIVisualEffect!
    
    
    var items = [Item]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var itemCell: ItemCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Visual Effect View (Blur)
//        effect = visualEffectView.effect
//        visualEffectView.effect = nil
        addItemView.layer.cornerRadius = 5
        
        // Image picker for add item
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        //Item Price as numbers only
        itemPriceTF.delegate = self
        itemPriceTF.keyboardType = .numberPad
        
        itemDescriptionTF.delegate = self
        itemDescriptionTF.text = "Add a description"
        itemDescriptionTF.textColor = UIColor.lightGray
        
        
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
            
            if let img = MyListVC.imageCache.object(forKey: item.imageURL as NSString) {
                cell.configureCell(item: item, image: img)
                return cell
            } else {
                cell.configureCell(item: item, image: nil)
                return cell
            }
            
        } else{
            return ItemCell()
        }
        
    }
    
    func animateIn(){
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        
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

//            self.visualEffectView.effect = nil
            
        }) { (success: Bool) in
            self.addItemView.removeFromSuperview()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if itemDescriptionTF.textColor == UIColor.lightGray {
            itemDescriptionTF.text = nil
            itemDescriptionTF.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if itemDescriptionTF.text.isEmpty {
            itemDescriptionTF.text = "Add a description"
            itemDescriptionTF.textColor = UIColor.lightGray
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
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
    
    @IBAction func addItemTapped(_ sender: Any) {
        guard let name = itemNameTF.text, name != "" else{
            print("TOOP: Item name must be entered")
            return
        }
        
        guard let price = itemPriceTF.text, price != "" else{
            print("TOOP: Item price must be entered")
            return
        }
        
        guard let description = itemDescriptionTF.text, description != "" else {
            print("TOOP: Item description must be entered")
            return
        }
        
        guard let image = imageAdd.image, imageSelected == true else {
            print("TOOP: Item image must be added")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_ITEM_IMAGES.child(imgUid).put(imgData, metadata: metaData) { (metadata, error) in
                if error != nil{
                    print("TOOP: Unable to upload image to Firebase strorage")
                } else {
                    print("TOOP: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postItemToFirebase(imageURL: url)
                        self.animateOut()
                    }
                }
            }
        }
    }
    
    func postItemToFirebase(imageURL: String){            
        
        let newitem: Dictionary<String, AnyObject> = [
            "name": itemNameTF.text as AnyObject,
            "price": Double(itemPriceTF.text!) as AnyObject,
            "description": itemDescriptionTF.text as AnyObject,
            "imageURL": imageURL as AnyObject,
            "user": DataService.ds.REF_CURRENT_USER.key as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_ITEMS.childByAutoId()
        firebasePost.setValue(newitem)
        
        //add item to the list of users items under current user
        let currItemUnderUser = DataService.ds.REF_CURRENT_USER.child("items").child(firebasePost.key)
        currItemUnderUser.setValue(true)
        
        itemNameTF.text = ""
        itemPriceTF.text = ""
        itemDescriptionTF.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "addImageIcon.png")
        
        self.items = []
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
