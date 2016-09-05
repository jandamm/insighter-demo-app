//
//  JDEvaluationCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

protocol EvaluationDelegate: JDCoordinatorDelegate {
    func logout()
}

class JDEvaluationCoordinator: JDCoordinator, EvaluationDelegate {
    
    weak var delegate: JDEvaluationCoordinatorDelegate?
    
    
    // MARK: - Coordinator
    
    override func start() {
        showEvaluationVC()
    }
    
    
    // MARK: - Show Methods
    
    private func showEvaluationVC() {
        let vc = EvaluationVC()
        
        vc.delegate = self
    
        setViewControllers(vc, animated: true)
    }
    
    func logout() {
        delegate?.loggedOut(self)
    }
    
    deinit {
        print("deinit eval coord")
    }
}
