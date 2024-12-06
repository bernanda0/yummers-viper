//
//  AreaDTO.swift
//  yummers
//
//  Created by mac.bernanda on 06/12/24.
//
struct AreasDTO: Codable {
    let meals: [AreaDTO]?
    
    func extractAreas() -> [AreaDTO] {
        return meals ?? []
    }
}

struct AreaDTO : Codable {
    let strArea : String?
}
