//
//  JDQuestionCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

protocol QuestionDelegate: JDCoordinatorDelegate {
    
}

class JDQuestionCoordinator: JDCoordinator, QuestionDelegate {
    
    weak var delegate: JDQuestionCoordinatorDelegate?
    
    
    // MARK: - Coordinator
    
    override func start() {
        showQuestionVC()
    }
    
    
    // MARK: - Show Methods
    
    private func showQuestionVC() {
        
        // TODO: - Implement Checking for Question
        
//        let vc = QuestionVC()
//        
//        vc.delegate = self
//        
//        pushViewController(vc, animated: true)
    }
}
