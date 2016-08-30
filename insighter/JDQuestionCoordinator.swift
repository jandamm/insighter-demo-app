//
//  JDQuestionCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol QuestionDelegate: Coordinator {
    
}

protocol JDQuestionDelegate: Coordinator {
    
}

class JDQuestionCoordinator: NSObject, Coordinator, QuestionDelegate {
    
    weak var delegate: JDQuestionDelegate?
    
    
    // MARK: - Coordinator
    
    let navigationController: UINavigationController
    
    var childCoordinator = [NSObject]()
    
    required init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    func start() {
        showQuestionVC()
    }
    
    
    // MARK: - Show Methods
    
    private func showQuestionVC() {
        
        // TODO: - Implement Checking for Question
        
//        let vc = QuestionVC()
//        
//        vc.delegate = self
//        
//        navigationController.pushViewController(vc, animated: true)
    }
}
