//
//  NibLoadableVC.swift
//  yummers
//
//  Created by mac.bernanda on 03/12/24.
//

import UIKit

protocol NibDelegate: UIViewController {
    static var nibName: String { get }
    init(sceneNavigator: Router?)
}

extension NibDelegate {
    static var nibName: String {
        return String(describing: Self.self)
    }

    // Default initializer with Router
    init(sceneNavigator: Router?) {
        self.init(nibName: Self.nibName, bundle: Bundle(for: Self.self))
        (self as? RouterInjectable)?.router = sceneNavigator
    }

    // Standard initializer for loading from Interface Builder
    init?(coder: NSCoder) {
        self.init(nibName: Self.nibName, bundle: Bundle(for: Self.self))
    }

    // Prevent accidental use of `nibName:bundle:` initializer directly
    @available(*, unavailable)
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
}
