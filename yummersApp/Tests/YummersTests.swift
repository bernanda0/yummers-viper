import Foundation
import XCTest
@testable import yummers


final class YummersTests: XCTestCase {
    func test_twoPlusTwo_isFour() {
        XCTAssertEqual(2+2, 4)
    }
}

final class MealsRepositoryTests: XCTestCase {
    func testFetchingMeals() async throws {
        let repository = DIContainer.shared.mealsRepository
        
        do {
            let meals = try await repository.searchMeals(key: "Chicken")
            meals.forEach { i in
                print(i.description)
            }
            XCTAssertFalse(meals.isEmpty, "Meals list should not be empty for 'Chicken'")
        } catch {
            XCTFail("Fetching meals failed with error: \(error)")
        }
    }
}

final class MealsUseCaseTests: XCTestCase {
    func testSearchMeal() async throws {
        let useCase = DIContainer.shared.mealsUseCase
        
        let meals = try await useCase.searchMeals(key: "Chicken")
        switch meals {
        case .success(let meals):
            meals.forEach { i in
                print(i)
            }
            XCTAssertFalse(meals.isEmpty, "Expected non-empty meals list for 'Chicken'.")
        case .failure(let error):
            XCTFail("Search meal use case failed with error: \(error.localizedDescription)")
        }
    }
    
    func testFilterMeal() async throws {
        let useCase = DIContainer.shared.mealsUseCase
        
        let meals = try await useCase.searchMeals(key: "Chicken")
        switch meals {
        case .success(let meals):
            let filtered = try await useCase.filterMealsByArea(from: meals, area: "American")
            filtered.forEach { i in
                print(i)
            }
            XCTAssertFalse(meals.isEmpty, "Expected non-empty meals list for 'Chicken'.")
        case .failure(let error):
            XCTFail("Search meal use case failed with error: \(error.localizedDescription)")
        }
    }
    
    func testGetMealAreas() async throws {
        let useCase = DIContainer.shared.mealsUseCase
        
        let areas = try await useCase.getMealAreas()
        switch areas {
            case .success(let areas):
            print(areas)
            XCTAssertFalse(areas.isEmpty, "Expected non-empty areas list.")
        case .failure(let error):
            XCTFail("Get meal areas use case failed with error: \(error.localizedDescription)")
        }
    }
}
