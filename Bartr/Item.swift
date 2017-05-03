//
//  Item.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 4/27/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import Foundation

class Item{
    
    private var _name: String!
    private var _price: Double!
    private var _description: String!
    private var _imageURL: String!
    private var _imageUID: String!
    private var _itemKey: String!
    
    var name: String{
        return _name
    }
    
    var price: Double{
        return _price
    }
    
    var description: String{
        return _description
    }
    
    var imageURL: String!{
        return _imageURL
    }
    
    var imageUID: String!{
        return _imageUID
    }
    
    var itemKey: String{
        return _itemKey
    }
    
    init(name: String, price: Double, description: String, imageURL: String, imageUID: String){
        self._name = name
        self._price = price
        self._description = description
        self._imageURL = imageURL
        self._imageUID = imageUID
        
    }
    
    init(itemKey: String, itemData: Dictionary<String, AnyObject>){
        self._itemKey = itemKey
        
        if let name = itemData["name"] as? String {
            self._name = name
        }
        
        if let price = itemData["price"] as? Double {
            self._price = price
        }
        
        if let description = itemData["description"] as? String {
            self._description = description
        }
        
        if let imageURL = itemData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let imageUID = itemData["imageUID"] as? String {
            self._imageUID = imageUID
        }
    }
}
