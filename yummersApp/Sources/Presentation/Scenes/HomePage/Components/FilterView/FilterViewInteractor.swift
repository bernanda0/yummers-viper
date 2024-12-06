//
//  FilterViewInteractor.swift
//  yummers
//
//  Created by mac.bernanda on 06/12/24.
//

import Foundation

protocol FilterViewInteractorProtocol {
    func getAreas(completion: @escaping (Result<[String], Error>) -> Void)
}

class FilterViewInteractor: FilterViewInteractorProtocol {
    private let mealsUseCase: MealsUseCase
    
    init(mealsUseCase: MealsUseCase) {
        self.mealsUseCase = mealsUseCase
    }
    
    func getAreas(completion: @escaping (Result<[String], any Error>) -> Void) {
        Task {
            do {
                let areas = try await mealsUseCase.getMealAreas()
                switch areas {
                case .success(let areas):
                    completion(.success(areas))
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
