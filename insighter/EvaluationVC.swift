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
    
    weak var delegate: EvaluationDelegate?
    
    @IBOutlet weak var scrollView: JDPagingScrollView!
    
    private var evalUserVC: EvaluationUserVC!
    private var evalCompVC: EvaluationCompanyVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        
        // TODO: Question asking
        let yourTimeInSeconds : Double = 1
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(yourTimeInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), { [weak self] in
            self?.askQuestions()
        })
    }
    
    
    // MARK: - Actions
    
    @IBAction func logout(sender: UIButton) {
        UserLoginService.sharedInstance.signOutUser(nil)
        
        self.delegate?.logout()
    }
    
    
    // MARK: - Private Methods
    
    private func setupScrollView() {
        evalUserVC = EvaluationUserVC()
        evalCompVC = EvaluationCompanyVC()
        
        addChildViewController(evalUserVC)
        scrollView.addSubview(evalUserVC.view)
        evalUserVC.didMoveToParentViewController(self)
        
        addChildViewController(evalCompVC)
        scrollView.addSubview(evalCompVC.view)
        evalCompVC.didMoveToParentViewController(self)
    }
    
    private func askQuestions() {
        guard UserLoginService.sharedInstance.ratedWeeksRelation(withDate: NSDate()).isDisjointWith([.This]) else {
            return NSLog("No question needs to be asked")
        }
        let questions = ConstantService.sharedInstance.ratingQuestions
        guard questions.count > 0 else {
            return NSLog("No questions available")
        }
        
        print("ask questions")
        
//        let vc = QuestionVC(withQuestions: questions)
//        let segue = JDSegueSlideFromBottom(identifier: nil, source: self, destination: vc)
//        
//        segue.perform()
    }
}
