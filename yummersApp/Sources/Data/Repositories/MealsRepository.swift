//
//  ScenarioGenerationRepository.swift
//  terapilah
//
//  Created by mac.bernanda on 19/08/24.
//

protocol MealsRepository {
    func searchMeals(key: String) async throws -> [MealDTO]
    func getAreas() async throws -> [AreaDTO]
}

class MealsRepositoryImpl: MealsRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func searchMeals(key: String) async throws -> [MealDTO] {
        return try await apiService.searchMeals(key: key)
    }
    
    func getAreas() async throws -> [AreaDTO] {
        return try await apiService.getMealsArea()
    }
}
