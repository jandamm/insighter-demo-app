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
    var childCoordinator: [Coordinator] { get }
    init(withNavigationController navigationController: UINavigationController)
    func start()
}
