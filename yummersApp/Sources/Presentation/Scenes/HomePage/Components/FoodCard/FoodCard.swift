//
//  FoodCard.swift
//  yummers
//
//  Created by mac.bernanda on 04/12/24.
//

import UIKit

class FoodCard: UIView {

    // MARK: - UI Components
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let areaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemGray4
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.masksToBounds = true
        
        addSubview(foodImageView)
        addSubview(nameLabel)
        addSubview(areaLabel)
        
        NSLayoutConstraint.activate([
            foodImageView.topAnchor.constraint(equalTo: topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            foodImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            
            nameLabel.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            areaLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            areaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            areaLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            areaLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            areaLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Configure Method
    func configure(with image: UIImage?, name: String, area: String) {
        foodImageView.image = image
        nameLabel.text = name
        areaLabel.text = area
    }
}

#Preview {
    FoodCard()
}
