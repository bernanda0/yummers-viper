//
//  MealsUseCase.swift
//  yummers
//
//  Created by mac.bernanda on 03/12/24.
//

protocol MealsUseCase {
    func searchMeals(key: String) async throws -> Result<[MealEntity], Error>
    func filterMealsByArea(from meals: [MealEntity], area : String) async throws -> [MealEntity]
    func getMealAreas() async throws -> Result<[String], Error>
}

class MealsUseCaseImpl: MealsUseCase {
    private let mealsRepository: MealsRepository

    init(mealsRepository: MealsRepository) {
        self.mealsRepository = mealsRepository
    }

    func searchMeals(key: String) async -> Result<[MealEntity], Error> {
        do {
            let mealsDTO = try await mealsRepository.searchMeals(key: key)
            let meals = mealsDTO.compactMap { MealEntity(from: $0) }
            return .success(meals)
        } catch {
            return .failure(error)
        }
    }
    
    func filterMealsByArea(from meals: [MealEntity], area: String) async throws -> [MealEntity] {
        await Task.yield() // Ensure the task is non-blocking
        
        let filteredMeals = meals.filter { $0.area.lowercased() == area.lowercased() }
        
        // Return the result
        return filteredMeals
    }
    
    func getMealAreas() async throws -> Result<[String], any Error> {
        do {
            let areasDTO = try await mealsRepository.getAreas()
            
            let areas = areasDTO.compactMap{ AreaEntity(from: $0).area }
            return .success(areas)
        } catch {
            return .failure(error)
        }
    }
}
