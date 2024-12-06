import UIKit
import Combine

class HomePageViewController: UIViewController, HomePageViewProtocol {
    var presenter: HomePagePresenterProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    private var meals: [MealEntity] = []
    private var originalMeals: [MealEntity] = []
    private var selectedArea: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        presenter?.viewDidLoad()
    }
    
    func showMeals(_ meals: [MealEntity]) {
        self.meals = meals
        self.originalMeals = meals
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
    
    func showFilterView() {
        let filterView = FilterViewController()
        let interactor = FilterViewInteractor(mealsUseCase: DIContainer.shared.mealsUseCase)
        let presenter = FilterViewPresenter(
            view: filterView,
            interactor: interactor
        )
        
        filterView.presenter = presenter
        
        print("WHWHWH")
        presenter.selectedAreaPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedArea in
                guard let previousSelectedArea = self?.selectedArea else { return }
                
                if (previousSelectedArea == selectedArea) {
                    print("WOWKKW")
                    guard let originalMeals = self?.originalMeals else { return }
                    self?.meals = originalMeals
                    print(originalMeals)
                    self?.collectionView.reloadData()

                }
                
                let a = self?.originalMeals.filter { selectedArea.contains($0.area) }
                self?.meals = a ?? []
                self?.collectionView.reloadData()
                self?.selectedArea = selectedArea
            }
            .store(in: &cancellables)
        
        addChild(filterView)
        view.addSubview(filterView.view)
        filterView.didMove(toParent: self)
        
        // Configure layout for the filter view
        filterView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterView.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            filterView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterView.view.heightAnchor.constraint(equalToConstant: 50) // Adjust height as needed
        ])
    }
    
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        presenter?.didSearchMeal(searchText)
        searchBar.resignFirstResponder()
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
        if meals.isEmpty {
            showEmptyStateMessage()
        } else {
            removeEmptyStateMessage()
        }
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
    
    // MARK: - Empty State
    private func showEmptyStateMessage() {
        let messageLabel = UILabel()
        messageLabel.text = "Start by searching for the food you want to look for 👆"
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.tag = 999 // Tag to identify the empty state view
        
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func removeEmptyStateMessage() {
        if let messageLabel = view.viewWithTag(999) {
            messageLabel.removeFromSuperview()
        }
    }
}


import SwiftUI
#Preview {
    PresenterWrapper{ r in
        HomePageRouter.createModule(router: r)
    }
}
