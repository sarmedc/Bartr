//
//  SigninVC.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 12/13/16.
//  Copyright © 2016 Sarmed Chaudhry. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SigninVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID){
            print("TOOP: ID found in keychain")
            performSegue(withIdentifier: "goToMyList", sender: nil)
        }
    }
    
//    func firebaseAuth(_ credential: FIRAuthCredential) {
//        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
//            if error != nil {
//                print("Unable to authenticate with Firebase - \(error)")
//            } else {
//                print("Successfully authenticated with Firebase")
//                if let user = user {
//                    let userData = ["provider": credential.provider]
//                    self.completeSignIn(id: user.uid, userData: userData)
//                }
//            }
//        })
//    }

    
    @IBAction func signinTapped(_ sender: Any) {
        if let email = emailTF.text, let pwd = pwdTF.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("TOOP: Email user authenticated with Firebase")
                    if let user = user {
//                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("TOOP: Unable to authenticate with Firebase using email")
                        } else {
                            print("TOOP: Successfully authenticated with Firebase")
                            if let user = user {
//                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        //DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.setString(id, forKey: KEY_UID)
        //let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("TOOP: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    


}

