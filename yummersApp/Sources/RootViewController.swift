//
//  ViewController.swift
//  yummers
//
//  Created by mac.bernanda on 02/12/24.
//

// RootViewController.swift
import UIKit

class RootViewController: UIViewController, RouterInjectable {
    var router: Router?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(router: Router? = nil) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toInitialPage()
    }
    
    private func toInitialPage() {
        guard let sceneNavigator = router else { return }
        
        let homePageViewController = HomePageRouter.createModule(router: sceneNavigator)
        sceneNavigator.setRootViewController(homePageViewController)
    }
    
}

