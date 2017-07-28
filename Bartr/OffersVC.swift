//
//  OffersVC.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 7/27/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import UIKit

class OffersVC: UIViewController {

    
    @IBOutlet weak var navDrawerBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navDrawerBtn.target = self.revealViewController()
        navDrawerBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
    }


}
