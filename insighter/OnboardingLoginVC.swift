//
//  OnboardingVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class OnboardingLoginVC: UIViewController {
    
    private var dropdownData: [String]!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTxt: JDTextField!
    @IBOutlet weak var passwordTxt: JDTextField!
    @IBOutlet weak var securitySectionSView: UIStackView!
    @IBOutlet weak var securityQuestionDropdown: JDDropdown!
    @IBOutlet weak var securityAnswerTxt: JDTextField!
    @IBOutlet weak var loginBtn: JDButton!
    
    
    // MARK: - Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeDropdown()
    }
    
    
    // MARK: - Actions
    
    @IBAction func loginPressed(sender: AnyObject) {
        print("button pressed")
    }

    
    // MARK: - Private Methods
    
    func initializeDropdown() {
        dropdownData = ConstantService.sharedInstance.securityQuestions
        securityQuestionDropdown.dataSource(dropdownData)
    }
}
