//
//  PresenterWrapper.swift
//  yummers
//
//  Created by mac.bernanda on 04/12/24.
//
import SwiftUI

struct PresenterWrapper: UIViewControllerRepresentable {
    let createModule: (Router) -> UIViewController
    let router: Router
    
    init (
        createModule: @escaping (Router) -> UIViewController
    ) {
        self.router = Router(navigationController: UINavigationController())
        self.createModule = createModule
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let viewController = createModule(router)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
