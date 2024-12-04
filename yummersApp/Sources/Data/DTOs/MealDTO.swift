//
//  ScenarioDTO.swift
//  terapilah
//
//  Created by mac.bernanda on 19/08/24.
//
import Foundation

struct MealsDTO: Codable {
    let meals: [MealDTO]?
    
    func extractMeals() -> [MealDTO] {
        return meals ?? []
    }
}

struct MealDTO: Codable {
    // Base properties
    let idMeal, strMeal, strCategory, strArea, strInstructions, strMealThumb, strYoutube, strDrinkAlternate: String?
    
    // Ingredients and measurements
    private let strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5: String?
    private let strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10: String?
    private let strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15: String?
    private let strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20: String?
    
    private let strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5: String?
    private let strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10: String?
    private let strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15: String?
    private let strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20: String?
    
    // Extracting ingredients using reflection
    var ingredients: [String] {
        (1...20).compactMap { index in
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            
            guard let ingredient = self.getValue(for: ingredientKey) as? String, !ingredient.isEmpty else {
                return nil
            }
            let measure = (self.getValue(for: measureKey) as? String)?.trimmingCharacters(in: .whitespaces) ?? ""
            return measure.isEmpty ? ingredient : "\(measure) \(ingredient)".trimmingCharacters(in: .whitespaces)
        }
    }
    
    // Custom function to get value using reflection
    private func getValue(for key: String) -> Any? {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children where child.label == key {
            return child.value
        }
        return nil
    }
    
    var description: String {
        """
        Meal Details:
        - ID: \(idMeal ?? "N/A")
        - Name: \(strMeal ?? "N/A")
        - Category: \(strCategory ?? "N/A")
        - Area: \(strArea ?? "N/A")
        - Ingredients:
        \(ingredients.map { "  - \($0)" }.joined(separator: "\n"))
        - Instructions: \(strInstructions ?? "N/A")
        """
    }
}
