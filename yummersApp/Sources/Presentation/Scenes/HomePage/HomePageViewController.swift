import UIKit

// HomePageViewController.swift
import UIKit

class HomePageViewController: UIViewController, HomePageViewProtocol {
    var presenter: HomePagePresenterProtocol?
    
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    private var meals: [MealEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        presenter?.viewDidLoad()
    }
    
    func showMeals(_ meals: [MealEntity]) {
        self.meals = meals
        collectionView.reloadData()
    }
    
    func showError(_ error: Error) {
        // Show error alert
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func showLoading() {
        // Implement loading indicator
    }
    
    func hideLoading() {
        // Hide loading indicator
    }
}

extension HomePageViewController: UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Setup Search Bar
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search food items..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        collectionView.reloadData()
    }
    
    // MARK: - Setup Collection View
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FoodCardCollectionViewCell.self, forCellWithReuseIdentifier: "FoodCardCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        // Constraints for collection view
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCardCell", for: indexPath) as! FoodCardCollectionViewCell
        
        let foodItem = meals[indexPath.row]
        
        
        cell.configure(with: foodItem.getThumbnailImage(), name: foodItem.name, area: foodItem.area)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeal = meals[indexPath.row]
        print("Tapped on meal: \(selectedMeal.name)")
        
        presenter?.didSelectMeal(selectedMeal)
    }

    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let spacing: CGFloat = 10
        let totalSpacing = (columns - 1) * spacing
        let width = (collectionView.frame.width - totalSpacing) / columns
        return CGSize(width: width, height: width * 1.3)
    }
}

import SwiftUI
#Preview {
    PresenterWrapper{ r in
        HomePageRouter.createModule(router: r)
    }
}
