//
//  HomePagePresenter.swift
//  yummers
//
//  Created by mac.bernanda on 04/12/24.
//

// HomePagePresenter.swift
import Foundation

protocol HomePageViewProtocol: AnyObject {
    func showMeals(_ meals: [MealEntity])
    func showError(_ error: Error)
    func showFilterView()
    func showLoading()
    func hideLoading()
}

protocol HomePagePresenterProtocol: Presentable {
    func didSelectMeal(_ meal: MealEntity)
    func didSearchMeal(_ searchText: String)
}

class HomePagePresenter: HomePagePresenterProtocol {
    weak var view: HomePageViewProtocol?
    private let interactor: HomePageInteractorProtocol
    private let router: HomePageRouterProtocol
    
    init(
        view: HomePageViewProtocol,
        interactor: HomePageInteractorProtocol,
        router: HomePageRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showLoading()
        view?.showFilterView()
    }
    
    func didSearchMeal(_ searchText: String) {
        self.interactor.fetchMeals(key: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let meals):
                    self?.view?.showMeals(meals)
                case .failure(let error):
                    self?.view?.showError(error)
                }
            }
        }
    }
    
    func didSelectMeal(_ meal: MealEntity) {
        router.navigateToMealDetail(meal)
    }
}
