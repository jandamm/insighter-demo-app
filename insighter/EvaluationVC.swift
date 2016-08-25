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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private lazy var evalUserVC: EvaluationUserVC = EvaluationUserVC()
    private lazy var evalCompVC: EvaluationCompanyVC = EvaluationCompanyVC()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        
        //TEST
        let yourTimeInSeconds : Double = 1
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(yourTimeInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.askQuestions()
        })
    }
    
    
    // MARK: - Private Methods
    
    private func setupScrollView() {
        
        addChildViewController(evalUserVC)
        scrollView.addSubview(evalUserVC.view)
        evalUserVC.didMoveToParentViewController(self)
        evalUserVC.view.frame.origin.x = 0
        
        addChildViewController(evalCompVC)
        scrollView.addSubview(evalCompVC.view)
        evalCompVC.didMoveToParentViewController(self)
        evalCompVC.view.frame.origin.x = view.frame.width
        
        scrollView.contentSize = CGSizeMake(view.frame.width * CGFloat(2), view.frame.height)
    }
    
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
