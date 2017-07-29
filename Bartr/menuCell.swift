//
//  menuCell.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 7/25/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import UIKit
import Firebase

class menuCell: UITableViewCell {
    
    
    @IBOutlet weak var navIconImage: UIImageView!
    @IBOutlet weak var navNameLabel: UILabel!
    
    var uid: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DataService.ds.REF_USERS.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.uid = FIRAuth.auth()?.currentUser?.uid
                for snap in snapshot{
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        if snap.key == self.uid! {
                            self.navNameLabel.text = userDict["username"] as? String
                            let ref = FIRStorage.storage().reference(forURL: (userDict["ppURL"] as? String)!)
                            ref.data(withMaxSize: 2 * 512 * 512, completion: { (data, error) in
                                if error != nil {
                                    print("TOOP: Unable to download image from Firebase")
                                } else {
                                    print("TOOP: Image downloaded from Firebase")
                                    if let imageData = data{
                                        if let img = UIImage(data: imageData){
                                            UIGraphicsBeginImageContext(CGSize(width: 48, height: 48))
                                            img.draw(in: CGRect(x: 0, y: 0, width: 48, height: 48))
                                            let newImage = UIGraphicsGetImageFromCurrentImageContext()
                                            UIGraphicsEndImageContext()
                                            self.navIconImage.image = newImage
                                            self.navIconImage.layer.borderWidth = 1
                                            self.navIconImage.layer.masksToBounds = false
                                            self.navIconImage.layer.borderColor = UIColor.black.cgColor
                                            self.navIconImage.layer.cornerRadius = self.navIconImage.frame.height/2
                                            self.navIconImage.clipsToBounds = true
                                            
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        })
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func configureMenuCell(){
    
    }

}
