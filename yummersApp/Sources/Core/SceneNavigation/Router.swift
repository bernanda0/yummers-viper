//
//  Router.swift
//  yummers
//
//  Created by mac.bernanda on 03/12/24.
//

import UIKit

protocol RouterInjectable: AnyObject {
    var router: Router? { get set }
}

class Router: RouterProtocol {
    private weak var navigationController: UINavigationController?
    private weak var rootViewController: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.rootViewController = navigationController.viewControllers.first
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        navigationController?.viewControllers = [viewController]
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRootViewController(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController?.present(viewController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController?.dismiss(animated: animated, completion: completion)
    }
}
