//
//  JDEvaluationCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol EvaluationDelegate: Coordinator {
    
}

class JDEvaluationCoordinator: NSObject, Coordinator, EvaluationDelegate {
    
    weak var delegate: JDEvaluationCoordinatorDelegate?
    
    
    // MARK: - Coordinator
    
    let navigationController: UINavigationController
    
    var childCoordinator = [NSObject]()
    
    required init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    func start() {
        showEvaluationVC()
    }
    
    
    // MARK: - Show Methods
    
    private func showEvaluationVC() {
        let vc = EvaluationVC()
        
        vc.delegate = self
        
        navigationController.pushViewController(vc, animated: true)
    }
}
