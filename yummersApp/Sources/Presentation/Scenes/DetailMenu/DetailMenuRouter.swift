//
//  HomePageRouter.swift
//  yummers
//
//  Created by mac.bernanda on 04/12/24.
//
import UIKit

protocol DetailMenuRouterProtocol {
//    func navigateToMealDetail(_ meal: MealEntity)
}

class DetailMenuRouter : DetailMenuRouterProtocol, RouterInjectable {
    var router: Router?
    private weak var viewController: UIViewController?
    
    init(router : Router, viewController: UIViewController) {
        self.router = router
        self.viewController = viewController
    }
    
    static func createModule(router: Router, for meal : MealEntity) -> UIViewController {
        let view = DetailMenuViewController()
        let router = DetailMenuRouter(router: router, viewController: view)
        let presenter = DetailMenuPresenter(
            view: view,
            router: router,
            for: meal
        )
        
        view.presenter = presenter
        
        return view
    }
}
