//
//  JDCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

/// Use this protocol for weak delegates of JDCoordinators to ViewControllers and other JDCoordinators.
public typealias JDCoordinatorDelegate = JDCoordinatorProtocol


/// Blueprint of JDCoordinators
@objc
public protocol JDCoordinatorProtocol: NSObjectProtocol {
    var navigationController: UINavigationController { get }
    init(withNavigationController navigationController: UINavigationController)
    func start()
}


/// JDCoordinator are meant to coordinate one or more ViewControllers
@objc
public class JDCoordinator: NSObject, JDCoordinatorProtocol {
    
    /// This navigationController pushes all ViewControllers
    public let navigationController: UINavigationController
    
    /// Initialize the JDCoordinator a UINavigationController
    public required init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    /// You need to override this method so it pushes the initial ViewController.
    public func start() {
        NSLog("Error: Start method hasn't been overridden")
    }
}


/// JDParentCoordinator are meant to coordinate one or more JDCoordinators and ViewControllers.
@objc
public class JDParentCoordinator: JDCoordinator {
    
    private var childCoordinator = [JDCoordinator]()
    
    /// Add a JDCoordinator as a child
    public func addChildCoordinator(coordinator: JDCoordinator) {
        childCoordinator.append(coordinator)
    }
    
    /// Remove a child
    public func removeChildCoordinator(coordinator: JDCoordinator) {
        if let index = childCoordinator.indexOf(coordinator) {
            childCoordinator.removeAtIndex(index)
        }
    }
}


public extension JDCoordinator {
    /// Convenience method to pushViewController directly within JDCoordinator
    public func pushViewController(viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    /// Convenience method to popViewControllerAnimated directly within JDCoordinator
    public func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        return navigationController.popViewControllerAnimated(animated)
    }
    
    /// Convenience method to popToViewController directly within JDCoordinator
    public func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return navigationController.popToViewController(viewController, animated: animated)
    }
    
    /// Convenience method to popToRootViewControllerAnimated directly within JDCoordinator
    public func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        return navigationController.popToRootViewControllerAnimated(animated)
    }
    
    /// Convenience method to setViewControllers directly within JDCoordinator
    public func setViewControllers(viewControllers: [UIViewController], animated: Bool) {
        navigationController.setViewControllers(viewControllers, animated: animated)
    }
}
