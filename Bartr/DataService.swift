//
//  DataService.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 4/26/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    static let ds = DataService()
    
    // DB References
    private var _REF_BASE = DB_BASE
    private var _REF_ITEMS = DB_BASE.child("items")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_ITEMS_LOC = "gs://bartr-2ea2c.appspot.com/item-pics/"
    
    // Storage References
    private var _REF_ITEM_IMAGES = STORAGE_BASE.child("item-pics")
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_ITEMS: FIRDatabaseReference{
        return _REF_ITEMS
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_ITEMS_LOC: String {
        return _REF_ITEMS_LOC
    }
    
    var REF_CURRENT_USER: FIRDatabaseReference{
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_ITEM_IMAGES: FIRStorageReference{
        return _REF_ITEM_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
