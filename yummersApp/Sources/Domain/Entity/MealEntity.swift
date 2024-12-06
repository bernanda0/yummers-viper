//
//  MealEntity.swift
//  yummers
//
//  Created by mac.bernanda on 03/12/24.
//
import Foundation
import UIKit
import Combine

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
    
    @Published private(set) var thumbnailImage: UIImage = UIImage(systemName: "photo")! // Placeholder image
    private var cancellables = Set<AnyCancellable>()
    
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
    
    init(from dto: MealDTO) {
        self.id = dto.idMeal ?? "Unknown ID"
        self.name = dto.strMeal ?? "Unknown Name"
        self.category = dto.strCategory ?? "Unknown Category"
        self.area = dto.strArea ?? "Unknown Area"
        self.instructions = dto.strInstructions ?? "No Instructions"
        self.thumbnailURL = URL(string: dto.strMealThumb ?? "")
        self.youtubeURL = URL(string: dto.strYoutube ?? "")
        self.drinkAlternate = dto.strDrinkAlternate ?? "No drink alternative"
        self.ingredients = dto.ingredients.isEmpty ? ["No Ingredients"] : dto.ingredients
        
        loadThumbnailImage()
    }
    
    private func loadThumbnailImage() {
        guard let url = thumbnailURL else { return }
        
        // Fetch the image asynchronously
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) ?? UIImage(systemName: "photo")! }
            .replaceError(with: UIImage(systemName: "photo")!)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.thumbnailImage = image
            }
            .store(in: &cancellables)
    }
    
    // For retrieving the current thumbnail image
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
