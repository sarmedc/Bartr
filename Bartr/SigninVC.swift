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

class SigninVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    
    @IBOutlet var signUpView: UIView!
    @IBOutlet weak var ppImageView: UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect: UIVisualEffect!
    
    var email: String!
    var pass: String!
    var imagePicker: UIImagePickerController!
    
    var imageSelected = false
    var isAddImage: Bool!
    
    var currUserName: FIRDatabaseReference!
    var currUserImage: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
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
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    self.email = email
                    self.pass = pwd
                    self.animateIn()
                }
            })
        }
    }
    
    func animateIn(){
        self.view.addSubview(signUpView)
        signUpView.center = self.view.center
        
        signUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        signUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.signUpView.alpha = 1
            self.signUpView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.signUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.signUpView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success: Bool) in
            self.signUpView.removeFromSuperview()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            if isAddImage == true {
                ppImageView.image = image
            }
            imageSelected = true
        } else {
            print("TOOP: A valid image was not selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addPPTapped(_ sender: Any) {
        isAddImage = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        guard let username = usernameTF.text, username != "" else {
            print("TOOP: Username must be entered")
            return
        }
        
        guard let image = ppImageView.image, imageSelected == true else {
            print("TOOP: Profile image must be added")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            FIRAuth.auth()?.createUser(withEmail: self.email, password: self.pass, completion: { (user, error) in
                if error != nil {
                    print("TOOP: Unable to authenticate with Firebase using email")
                } else {
                    print("TOOP: Successfully authenticated with Firebase")
                    //open view (animateIn())
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                    
                    DataService.ds.REF_USER_IMAGES.child(imgUid).put(imgData, metadata: metaData) { (metadata, error) in
                        if error != nil{
                            print("TOOP: Unable to upload image to Firebase strorage")
                        } else {
                            print("TOOP: Successfully uploaded image to Firebase storage")
                            let downloadURL = metadata?.downloadURL()?.absoluteString
                            if let url = downloadURL {
                                self.postUserToFirebase(imageURL: url, imageUID: imgUid, username: username)
                            }
                        }
                    }
                }
            })
        }
        
        self.animateOut()
        
    }
    
    func postUserToFirebase(imageURL: String, imageUID: String, username: String){
        
//        let newitem: Dictionary<String, AnyObject> = [
//            "name": itemNameTF.text as AnyObject,
//            "price": Double(itemPriceTF.text!) as AnyObject,
//            "description": itemDescriptionTF.text as AnyObject,
//            "imageURL": imageURL as AnyObject,
//            "imageUID": imageUID as AnyObject,
//            "user": DataService.ds.REF_CURRENT_USER.key as AnyObject
//        ]
        
        //let firebasePost = DataService.ds.REF_ITEMS.childByAutoId()
       // firebasePost.setValue(newitem)
        
        //add item to the list of users items under current user
        currUserName = DataService.ds.REF_CURRENT_USER.child("username")
        currUserName.setValue(username)
        
        currUserImage = DataService.ds.REF_CURRENT_USER.child("ppURL")
        currUserImage.setValue(imageURL)
        
        
        
        usernameTF.text = ""
        imageSelected = false
        ppImageView.image = UIImage(named: "addImageIcon.png")
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        ppImageView.image = UIImage(named: "addImageIcon.png")
        usernameTF.text = ""
        animateOut()
        
    }
    
    
    func completeSignIn(id: String, userData: Dictionary<String,String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("TOOP: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToMyList", sender: nil)
    }
    
    


}

