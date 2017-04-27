//
//  DataService.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 4/26/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_ITEMS = DB_BASE.child("items")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_ITEMS: FIRDatabaseReference{
        return _REF_ITEMS
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
