//
//  ItemCell.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 4/26/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import UIKit
import Firebase

protocol ItemCellDelegate: class {
    func reloadItems()
}

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    weak var delegate: ItemCellDelegate?
    
    var item: Item!
    var currUserItems: FIRDatabaseReference!
    var currItem: FIRDatabaseReference!
    var currImage: FIRStorageReference!
    var imageStorage: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(item: Item, image: UIImage? = nil){
        self.item = item
        self.itemName.text = item.name
        self.itemPrice.text = "\(item.price)"
        self.itemDescription.text = item.description
        self.imageStorage = item.imageUID
        
        currUserItems = DataService.ds.REF_CURRENT_USER.child("items").child(item.itemKey)
        currItem = DataService.ds.REF_ITEMS.child(item.itemKey)
        currImage = DataService.ds.REF_ITEM_IMAGES
        
        if image != nil{
            self.itemImage.image = image
        } else {
            let ref = FIRStorage.storage().reference(forURL: item.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("TOOP: Unable to download image from Firebase")
                } else {
                    print("TOOP: Image downloaded from Firebase")
                    if let imageData = data{
                        if let img = UIImage(data: imageData){
                            self.itemImage.image = img
                            MyListVC.imageCache.setObject(img, forKey: item.imageURL as NSString)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        //print("TOOP: \(currItem)")
        DataService.ds.REF_ITEMS.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot{
                    print("SNAP \(snap)")
                    if snap.key == self.currItem.key {
                        MyListVC.sharedInstance?.viewEdit(snap: snap)
                    }
                }
            }
        })
        
    }
    
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        currUserItems.removeValue()
        currItem.removeValue()
        print(imageStorage)
        let imageLoc = DataService.ds.REF_ITEMS_LOC + imageStorage
        FIRStorage.storage().reference(forURL: imageLoc).delete{ (error) in
            if error != nil {
                // error
            } else {
                // success
            }
        }
        
                
        MyListVC.sharedInstance?.reloadItems()
    }
}
