// SceneBViewController.swift
import UIKit

class DetailMenuViewController: UIViewController, DetailMenuViewProtocol {
    var presenter: DetailMenuPresenterProtocol?
    
    // UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var areaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var instructionsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    private lazy var ingredientsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews to content view
        [mealImageView, nameLabel, categoryLabel, areaLabel,
         instructionsTextView, ingredientsStackView].forEach {
            contentView.addSubview($0)
        }
        
        // Add loading indicator
        view.addSubview(loadingIndicator)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Meal Image Constraints
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mealImageView.heightAnchor.constraint(equalToConstant: 250),
            
            // Name Label Constraints
            nameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Category Label Constraints
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Area Label Constraints
            areaLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            areaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            areaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Instructions TextView Constraints
            instructionsTextView.topAnchor.constraint(equalTo: areaLabel.bottomAnchor, constant: 16),
            instructionsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instructionsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Ingredients StackView Constraints
            ingredientsStackView.topAnchor.constraint(equalTo: instructionsTextView.bottomAnchor, constant: 16),
            ingredientsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ingredientsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Loading Indicator Constraints
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showMeal(_ meal: MealEntity) {
        // Update UI with meal details
        nameLabel.text = meal.name
        categoryLabel.text = "Category: \(meal.category)"
        areaLabel.text = "Area: \(meal.area)"
        instructionsTextView.text = meal.instructions
        
        mealImageView.image = meal.getThumbnailImage()
        
        // Clear previous ingredients
        ingredientsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add ingredients
        let ingredientsHeaderLabel = UILabel()
        ingredientsHeaderLabel.text = "Ingredients:"
        ingredientsHeaderLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        ingredientsStackView.addArrangedSubview(ingredientsHeaderLabel)
        
        meal.ingredients.forEach { ingredient in
            let ingredientLabel = UILabel()
            ingredientLabel.text = "• \(ingredient)"
            ingredientLabel.numberOfLines = 0
            ingredientsStackView.addArrangedSubview(ingredientLabel)
        }
    }
    
    func showError(_ error: any Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func showLoading() {
//        loadingIndicator.startAnimating()
//        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
//        loadingIndicator.stopAnimating()
//        view.isUserInteractionEnabled = true
    }
}

// SwiftUI Preview
import SwiftUI
#Preview {
    PresenterWrapper { r in
        let mockMeal = MealEntity(
            id: "1",
            name: "Pasta Carbonara",
            category: "Pasta",
            area: "Italian",
            instructions: "Cook pasta, make sauce with eggs and cheese...",
            thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/wyxwsp1486979827.jpg"),
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=IO0issT0Rmc"),
            drinkAlternate: "",
            ingredients: [
                "Pasta",
                "Eggs",
                "Cheese",
                "Bacon"
            ]
        )
        
        return DetailMenuRouter.createModule(router: r, for: mockMeal)
    }
}

