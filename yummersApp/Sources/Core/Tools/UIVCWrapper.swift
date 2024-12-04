//
//  UIVCWrapper.swift
//  yummers
//
//  Created by mac.bernanda on 02/12/24.
//
import SwiftUI
import UIKit

struct UIVCWrapper<T: UIViewController>: UIViewControllerRepresentable {
    let nibName: String?
    let bundle: Bundle?

    init(nibName: String? = nil, bundle: Bundle? = nil) {
        self.nibName = nibName
        self.bundle = bundle
    }

    func makeUIViewController(context: Context) -> T {
        if let nibName = nibName {
            return T(nibName: nibName, bundle: bundle)
        } else {
            return T()
        }
    }

    func updateUIViewController(_ uiViewController: T, context: Context) {}
}
