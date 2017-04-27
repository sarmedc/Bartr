//
//  ItemCell.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 4/26/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var item: Item!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(item: Item){
        self.item = item
        self.itemName.text = item.name
        self.itemPrice.text = "\(item.price)"
        self.itemDescription.text = item.description
//        self.itemImage = item.imageURL
    }

}
