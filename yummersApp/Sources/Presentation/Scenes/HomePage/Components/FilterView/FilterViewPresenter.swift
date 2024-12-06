//
//  FilterViewPresenter.swift
//  yummers
//
//  Created by mac.bernanda on 06/12/24.
//
import Foundation
import Combine

protocol FilterViewProtocol: AnyObject {
    func showAreas(_ areas: [String])
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
}

protocol AreaSelectionPublisherProtocol {
    var selectedAreaPublisher: AnyPublisher<String, Never> { get }
    func selectArea(_ area: String)
}

class AreaSelectionPublisher {
    private let selectedAreaSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func selectArea(_ area: String) {
        selectedAreaSubject.send(area)
    }
    
    var selectedAreaPublisher: AnyPublisher<String, Never> {
        selectedAreaSubject.eraseToAnyPublisher()
    }
}

protocol FilterViewPresenterProtocol: Presentable {
    func didSelectArea(in area: String)
}

class FilterViewPresenter: FilterViewPresenterProtocol {
    weak var view: FilterViewProtocol?
    private let interactor: FilterViewInteractorProtocol
    private var areaSelectionPublisher = AreaSelectionPublisher()
    
    var selectedAreaPublisher: AnyPublisher<String, Never> {
        areaSelectionPublisher.selectedAreaPublisher
    }
    
    init(
        view: FilterViewProtocol,
        interactor: FilterViewInteractorProtocol
    ) {
        self.view = view
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        view?.showLoading()
        self.interactor.getAreas { [weak self] result in
            switch result {
                case .success(let areas):
                    self?.view?.showAreas(areas)
                case .failure(let error):
                    self?.view?.showError(error)
            }
        }
    }
    
    func didSelectArea(in area: String) {
        areaSelectionPublisher.selectArea(area)
    }
}

import SwiftUI
#Preview {
    PresenterWrapper { r in
        let filterView = FilterViewController()
        let interactor = FilterViewInteractor(mealsUseCase: DIContainer.shared.mealsUseCase)
        let presenter = FilterViewPresenter(
            view: filterView,
            interactor: interactor
        )
        
        filterView.presenter = presenter
        
        return filterView
    }
}
