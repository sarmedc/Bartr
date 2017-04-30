//
//  ItemCell.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 4/26/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import UIKit
import Firebase

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var item: Item!
    var currUserItems: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(item: Item, image: UIImage? = nil){
        self.item = item
        self.itemName.text = item.name
        self.itemPrice.text = "\(item.price)"
        self.itemDescription.text = item.description
        
        currUserItems = DataService.ds.REF_CURRENT_USER.child("items").child(item.itemKey)
        
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
}
