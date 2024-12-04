//
//  FoodCardCollectionView.swift
//  yummers
//
//  Created by mac.bernanda on 04/12/24.
//

import UIKit

class FoodCardCollectionViewCell: UICollectionViewCell {
    
    let foodCard = FoodCard(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(foodCard)
        foodCard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            foodCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            foodCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            foodCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            foodCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with image: UIImage?, name: String, area: String) {
        foodCard.configure(with: image, name: name, area: area)
    }
}

#Preview {
    FoodCardCollectionViewCell()
}
