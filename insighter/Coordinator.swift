//
//  Coordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol Coordinator: NSObjectProtocol {
    var navigationController: UINavigationController { get }
    var childCoordinator: [NSObject] { get set }
    init(withNavigationController navigationController: UINavigationController)
    func start()
}

extension Coordinator {
    func removeSubCoordinator<C where C: NSObject, C: Coordinator>(finishedCoordinator: C) {
        if let index = childCoordinator.indexOf(finishedCoordinator) {
            childCoordinator.removeAtIndex(index)
        }
    }
}
