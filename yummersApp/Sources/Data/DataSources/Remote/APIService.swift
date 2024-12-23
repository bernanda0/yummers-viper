//
//  APIService.swift
//  terapilah
//
//  Created by mac.bernanda on 19/08/24.
//

protocol APIService {
    func searchMeals(key: String) async throws -> [MealDTO]
    func getMealsArea() async throws -> [AreaDTO]
}

class APIServiceImpl: APIService {
    private let apiManager: APIManager = APIManager.shared()
    
    func searchMeals(key: String) async throws -> [MealDTO] {
        let params: [String: Any] = [
            "s": "\(key)",
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            apiManager.call(type: MealEndpoint.search, params: params) { (result: Result<MealsDTO, Error>) in
                switch result {
                case .success(let mealsDTO):
                    continuation.resume(returning: mealsDTO.extractMeals())
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getMealsArea() async throws -> [AreaDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiManager.call(type: MealEndpoint.getAreas) { (result: Result<AreasDTO, Error>) in
                switch result {
                case .success(let areasDTO):
                    continuation.resume(returning: areasDTO.extractAreas())
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
