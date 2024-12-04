//
//  HomePageInteractor.swift
//  yummers
//
//  Created by mac.bernanda on 04/12/24.
//

import Foundation

protocol HomePageInteractorProtocol {
    func fetchMeals(key: String, completion: @escaping (Result<[MealEntity], Error>) -> Void)
}

class HomePageInteractor: HomePageInteractorProtocol {
    private let mealsUseCase: MealsUseCase
    
    init(mealsUseCase: MealsUseCase) {
        self.mealsUseCase = mealsUseCase
    }
    
    func fetchMeals(key: String, completion: @escaping (Result<[MealEntity], Error>) -> Void) {
        Task {
            do {
                let meals = try await mealsUseCase.searchMeals(key: key)
                switch meals {
                case .success(let meals):
                    completion(.success(meals))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

}
