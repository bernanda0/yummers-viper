//
//  HomePageRouter.swift
//  yummers
//
//  Created by mac.bernanda on 04/12/24.
//
import UIKit

protocol HomePageRouterProtocol {
    func navigateToMealDetail(_ meal: MealEntity)
}

class HomePageRouter : HomePageRouterProtocol, RouterInjectable {
    var router: Router?
    private weak var viewController: UIViewController?
    
    init(router : Router, viewController: UIViewController) {
        self.router = router
        self.viewController = viewController
    }
    
    static func createModule(router: Router) -> UIViewController {
        let view = HomePageViewController()
        let interactor = HomePageInteractor(mealsUseCase: DIContainer.shared.mealsUseCase)
        let router = HomePageRouter(router: router, viewController: view)
        let presenter = HomePagePresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        
        return view
    }
    
    func navigateToMealDetail(_ meal: MealEntity) {
        guard let sceneNavigator = router else { return }
        
        // Create Scene B View Controller
        let detailMenuViewController = DetailMenuRouter.createModule(router: sceneNavigator, for: meal)
        sceneNavigator.push(detailMenuViewController)
    }
}
