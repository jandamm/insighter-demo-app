//
//  JDAppCoordinatorDelegate.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

typealias JDAppCoordinatorDelegate = protocol<JDOnboardingCoordinatorDelegate, JDLoginCoordinatorDelegate, JDQuestionCoordinatorDelegate, JDEvaluationCoordinatorDelegate>


protocol JDOnboardingCoordinatorDelegate: Coordinator {
    func onboardingEnded<C where C: NSObject, C: Coordinator>(finishedCoordinator: C)
}

protocol JDLoginCoordinatorDelegate: Coordinator {
    func loginEnded<C where C: NSObject, C: Coordinator>(finishedCoordinator: C)
}

protocol JDQuestionCoordinatorDelegate: Coordinator {
    
}

protocol JDEvaluationCoordinatorDelegate: Coordinator {
    
}
