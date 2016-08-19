//
//  EvaluationVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import Firebase

class EvaluationVC: UIViewController {
    //TEST
    @IBOutlet weak var dataLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataLbl.text = UserLoginService.sharedInstance.data
        
        //TEST
        let yourTimeInSeconds : Double = 1
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(yourTimeInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.askQuestions()
        })
    }
    
    
    @IBAction func resetQuestion(sender: UIButton) {
        guard let userID = UserLoginService.sharedInstance.userID else {
            return
        }
        
        FIRDatabase.database().reference().child(DBPathKeys.user.rawValue).child(userID).child(DBValueKeys.User.lastRated.rawValue).removeValue()
    }
    
    @IBAction func signOut(sender: UIButton) {
        UserLoginService.sharedInstance.signOutUser()
        
        performSegueWithIdentifier(Segue.EvaluationToOnboarding.rawValue, sender: nil)
    }
    
    
    // MARK: - Private Methods
    
    private func askQuestions() {
        guard UserLoginService.sharedInstance.ratedWeeksRelation(withDate: NSDate()).isDisjointWith([.This]) else {
            return NSLog("No question needs to be asked")
        }
        let questions = ConstantService.sharedInstance.ratingQuestions
        guard questions.count > 0 else {
            return NSLog("No questions available")
        }
        
        let vc = QuestionVC(withQuestions: questions)
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
