//
//  MealEntity.swift
//  yummers
//
//  Created by mac.bernanda on 03/12/24.
//

import Foundation
import UIKit

class MealEntity {
    let id: String
    let name: String
    let category: String
    let area: String
    let instructions: String
    let thumbnailURL: URL?
    let youtubeURL: URL?
    let drinkAlternate: String
    let ingredients: [String]
    
    private var thumbnailImage: UIImage = UIImage(systemName: "photo")! // Placeholder image
    private var isImageLoaded = false
    
    init(id: String, name: String, category: String, area: String, instructions: String, thumbnailURL: URL?, youtubeURL: URL?, drinkAlternate: String, ingredients: [String]) {
        self.id = id
        self.name = name
        self.category = category
        self.area = area
        self.instructions = instructions
        self.thumbnailURL = thumbnailURL
        self.youtubeURL = youtubeURL
        self.drinkAlternate = drinkAlternate
        self.ingredients = ingredients
        
        loadThumbnailImage()
    }
    
    // Initializer that accepts MealDTO and handles optional values
    init(from dto: MealDTO) {
        self.id = dto.idMeal ?? "Unknown ID"
        self.name = dto.strMeal ?? "Unknown Name"
        self.category = dto.strCategory ?? "Unknown Category"
        self.area = dto.strArea ?? "Unknown Area"
        self.instructions = dto.strInstructions ?? "No Instructions"
        self.thumbnailURL = URL(string: dto.strMealThumb ?? "")
        self.youtubeURL = URL(string: dto.strYoutube ?? "")
        self.drinkAlternate = dto.strDrinkAlternate ?? "No drink alternative"
        
        // Handling ingredients from DTO
        self.ingredients = dto.ingredients.isEmpty ? ["No Ingredients"] : dto.ingredients
        loadThumbnailImage()
    }
    
    private func loadThumbnailImage() {
        guard let url = thumbnailURL, !isImageLoaded else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.thumbnailImage = image
                    self.isImageLoaded = true
                }
            } catch {
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
    
    func getThumbnailImage() -> UIImage {
        return thumbnailImage
    }
    
    // Custom description for debugging
    var description: String {
        """
        Meal Details:
        - ID: \(id)
        - Name: \(name)
        - Category: \(category)
        - Area: \(area)
        - Ingredients: \(ingredients.joined(separator: ", "))
        - Instructions: \(instructions)
        - Thumbnail: \(thumbnailURL?.absoluteString ?? "No URL")
        - YouTube: \(youtubeURL?.absoluteString ?? "No URL")
        """
    }
}
