//
//  AreaEntity.swift
//  yummers
//
//  Created by mac.bernanda on 06/12/24.
//

struct AreaEntity {
    let area : String
    
    init(from dto: AreaDTO) {
        self.area = dto.strArea ?? ""
    }
}
