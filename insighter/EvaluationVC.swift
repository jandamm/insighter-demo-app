//
//  EvaluationVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class EvaluationVC: UIViewController {
    //TEST for beta
    @IBOutlet weak var dataLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataLbl.text = UserLoginService.sharedInstance.data
    }
    
    
    @IBAction func notif(sender: UIButton) {
        NotificationService.sharedInstance.setupNotifications()
    }
    
    @IBAction func signOut(sender: UIButton) {
        UserLoginService.sharedInstance.signOutUser()
        
        performSegueWithIdentifier(Segue.EvaluationToOnboarding.rawValue, sender: nil)
    }
    

}
