//
//  HomePagePresenter.swift
//  yummers
//
//  Created by mac.bernanda on 04/12/24.
//

// HomePagePresenter.swift
import Foundation

protocol DetailMenuViewProtocol: AnyObject {
    func showMeal(_ meal: MealEntity)
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
}

protocol DetailMenuPresenterProtocol: Presentable {
    func didOpenYouTube(url: URL)
}

class DetailMenuPresenter: DetailMenuPresenterProtocol {
    weak var view: DetailMenuViewProtocol?
    private let router: DetailMenuRouterProtocol
    private let meal: MealEntity
    
    init(
        view: DetailMenuViewProtocol,
        router: DetailMenuRouterProtocol,
        for meal : MealEntity
    ) {
        self.view = view
        self.router = router
        self.meal = meal
    }
    
    func viewDidLoad() {
        view?.showLoading()
        view?.showMeal(meal)
    }
    
    func didOpenYouTube(url: URL) {
        print("YEEET")
    }
}
