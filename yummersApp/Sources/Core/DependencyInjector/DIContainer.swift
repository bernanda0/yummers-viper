//
//  DIContainer.swift
//  yummers
//
//  Created by mac.bernanda on 03/12/24.
//

final class DIContainer {
    lazy var apiService: APIService = APIServiceImpl()
    lazy var mealsRepository: MealsRepository = MealsRepositoryImpl(apiService: apiService)
    lazy var mealsUseCase: MealsUseCase = MealsUseCaseImpl(mealsRepository: mealsRepository)
    
    // Singleton instance to ensure centralized DI management
    static let shared = DIContainer()
    
    private init() {}
}
