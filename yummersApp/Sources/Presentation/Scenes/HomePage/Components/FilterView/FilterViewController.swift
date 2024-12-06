//
//  FilterViewController.swift
//  yummers
//
//  Created by mac.bernanda on 06/12/24.
//

import UIKit

class FilterViewController: UIViewController, FilterViewProtocol {
    var presenter: FilterViewPresenterProtocol?
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var selectedArea: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Configure ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        // Configure StackView
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Configure ActivityIndicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            scrollView.heightAnchor.constraint(equalToConstant: 50),
            
            // StackView inside ScrollView
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // ActivityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - FilterViewProtocol Methods
    
    func showAreas(_ areas: [String]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear old buttons
            
            for area in areas {
                let button = UIButton(type: .system)
                button.setTitle(area, for: .normal)
                button.setTitleColor(.systemBlue, for: .normal)
                button.backgroundColor = .systemGray5
                button.layer.cornerRadius = 8
                button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                button.tag = areas.firstIndex(of: area) ?? 0
                button.addTarget(self, action: #selector(self.areaButtonTapped(_:)), for: .touchUpInside)
                self.stackView.addArrangedSubview(button)
            }
        }
    }

    
    func showError(_ error: Error) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    
    @objc private func areaButtonTapped(_ sender: UIButton) {
        guard let area = sender.titleLabel?.text else { return }
        
        // Update the selected button UI
        updateSelectedAreaUI(selectedButton: sender, area: area)
        presenter?.didSelectArea(in: area)
    }
    
    private func updateSelectedAreaUI(selectedButton: UIButton, area: String) {
        // Deselect all buttons
        stackView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else { return }
            button.backgroundColor = .systemGray5
            button.setTitleColor(.systemBlue, for: .normal)
        }
        
        // Highlight the selected button
        selectedButton.backgroundColor = .systemBlue
        selectedButton.setTitleColor(.white, for: .normal)
        
        // Update the selected area
        selectedArea = area
    }
}


