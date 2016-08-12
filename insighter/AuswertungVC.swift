//
//  AuswertungVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class AuswertungVC: UIViewController {
    //TEST
    @IBOutlet weak var dataLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dataCheck(sender: UIButton) {
        dataLbl.text = UserLoginService.sharedInstance.data
    }
    
    
    @IBAction func signOut(sender: UIButton) {
        UserLoginService.sharedInstance.signOutUser()
        
        performSegueWithIdentifier(Segue.AuswertungToOnboarding.rawValue, sender: nil)
    }
    

}
